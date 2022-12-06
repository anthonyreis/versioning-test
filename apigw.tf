resource "aws_api_gateway_rest_api" "CatalogAPI" {
 name        = "CatalogAPI"
 description = "An API for demo purposes."
}
 
resource "aws_api_gateway_resource" "CatalogAPIResource" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 parent_id   = aws_api_gateway_rest_api.CatalogAPI.root_resource_id
 path_part   = "catalog"
}
 
resource "aws_iam_role" "role" {
 name = "serverless_example_lambda"
 
 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
# HTTP API Gateway
resource "aws_api_gateway_method" "ListCatalog" {
 rest_api_id   = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id   = aws_api_gateway_resource.CatalogAPIResource.id
 http_method   = "GET"
 authorization = "NONE"
 
 request_parameters = {
   "method.request.header.Version" = true
 }
}
 
resource "aws_api_gateway_integration" "CatalogIntegration" {
 rest_api_id             = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id             = aws_api_gateway_resource.CatalogAPIResource.id
 http_method             = aws_api_gateway_method.ListCatalog.http_method
 type                    = "HTTP"
 integration_http_method = "GET"
 
 request_parameters = {
   "integration.request.path.version" = "method.request.header.Version"
 }
 
 uri = "https://google.com.br/{version}"
 depends_on = [
   aws_api_gateway_method.ListCatalog,
   aws_api_gateway_resource.CatalogAPIResource,
   aws_api_gateway_rest_api.CatalogAPI
 ]
 
 #uri =  "${aws_api_gateway_deployment.CatalogAPI.invoke_url}${aws_api_gateway_stage.CatalogAPI.stage_name}/${aws_api_gateway_resource.CatalogAPIResource.path_part}/{version}" #"https://ny1aiu24rf.execute-api.us-east-1.amazonaws.com/dev/catalog/{version}" # FIXME
}
 
resource "aws_api_gateway_deployment" "CatalogAPI" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id

 depends_on = [
   aws_api_gateway_method.ListCatalog,
   aws_api_gateway_resource.CatalogAPIResource,
   aws_api_gateway_rest_api.CatalogAPI,
   aws_api_gateway_method.ListCatalogV1,
   aws_api_gateway_method.ListCatalogV2,
   aws_api_gateway_integration.CatalogIntegrationV1,
   aws_api_gateway_integration.CatalogIntegrationV2
 ]
 
 triggers = {
   redeployment = sha1(jsonencode([
    aws_api_gateway_method.ListCatalog,
    aws_api_gateway_resource.CatalogAPIResource,
    aws_api_gateway_rest_api.CatalogAPI,
    aws_api_gateway_method.ListCatalogV1,
    aws_api_gateway_method.ListCatalogV2,
    aws_api_gateway_integration.CatalogIntegrationV1,
    aws_api_gateway_integration.CatalogIntegrationV2
    ]))
 }

  lifecycle {
    create_before_destroy = true
  }
}
 
resource "aws_api_gateway_stage" "CatalogAPI" {
 deployment_id = aws_api_gateway_deployment.CatalogAPI.id
 rest_api_id   = aws_api_gateway_rest_api.CatalogAPI.id
 stage_name    = "dev"

 depends_on = [
   aws_api_gateway_deployment.CatalogAPI,
   aws_api_gateway_rest_api.CatalogAPI
 ]
}
