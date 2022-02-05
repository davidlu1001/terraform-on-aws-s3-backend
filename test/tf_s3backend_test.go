package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

// Test the Terraform module in examples/terratest/ using Terratest
func TestTerraformS3Backend(t *testing.T) {
	t.Parallel()

	uniqueId := random.UniqueId()

	awsRegion := "ap-southeast-2"
	nameSpace := "default"
	forceDestroyState := true

	// Expected name of the backend
	bucketName := fmt.Sprintf("state-bucket-%s", nameSpace)
	dynamodbName := fmt.Sprintf("state-lock-%s", nameSpace)

	key := fmt.Sprintf("%s/terraform.tfstate", uniqueId)

	// Deploy the module, configuring it to use the S3 bucket as an S3 backend
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/terratest/",

		Vars: map[string]interface{}{
			"region":              awsRegion,
			"namespace":           nameSpace,
			"force_destroy_state": forceDestroyState,
		},

		BackendConfig: map[string]interface{}{
			"bucket": bucketName,
			"key":    key,
			"region": awsRegion,
		},

		// How to set Environment variables when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_PROFILE": "privileged-admin-test",
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	outputS3Bucket := terraform.Output(t, terraformOptions, "s3_bucket")
	outputDynamodbTable := terraform.Output(t, terraformOptions, "dynamodb_table")
	require.Equal(t, bucketName, outputS3Bucket)
	require.Equal(t, dynamodbName, outputDynamodbTable)

	// Verify that S3 Bucket has versioning enabled
	actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketName)
	expectedStatus := "Enabled"
	require.Equal(t, expectedStatus, actualStatus)
}
