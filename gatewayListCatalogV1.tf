# V1 API Gateway

resource "aws_api_gateway_resource" "CatalogAPIResourceV1" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 parent_id   = aws_api_gateway_resource.CatalogAPIResource.id
 path_part   = "v1"
}
 
resource "aws_api_gateway_method" "ListCatalogV1" {
 rest_api_id   = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id   = aws_api_gateway_resource.CatalogAPIResourceV1.id
 http_method   = "GET"
 authorization = "NONE"
}
 
resource "aws_api_gateway_integration" "CatalogIntegrationV1" {
 rest_api_id             = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id             = aws_api_gateway_resource.CatalogAPIResourceV1.id
 http_method             = aws_api_gateway_method.ListCatalogV1.http_method
 type                    = "AWS_PROXY"
 integration_http_method = "POST"
 uri                     = aws_lambda_function.lambdav1.invoke_arn
}
 
resource "aws_lambda_permission" "apigw_lambdav1" {
 statement_id  = "AllowExecutionFromAPIGateway"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.lambdav1.function_name
 principal     = "apigateway.amazonaws.com"
 
 source_arn = "${aws_api_gateway_rest_api.CatalogAPI.execution_arn}/*/*" # FIXME
}
 
resource "aws_lambda_function" "lambdav1" {
 filename      = "lambdav1.zip"
 function_name = "lambdav1"
 role          = aws_iam_role.role.arn
 handler       = "lambdav1.handler"
 runtime       = "nodejs16.x"
 
 source_code_hash = filebase64sha256("lambdav1.zip")
}