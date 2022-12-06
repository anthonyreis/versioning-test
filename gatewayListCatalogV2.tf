# V2 API Gateway

resource "aws_api_gateway_resource" "CatalogAPIResourceV2" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 parent_id   = aws_api_gateway_resource.CatalogAPIResource.id
 path_part   = "v2"
}
 
resource "aws_api_gateway_method" "ListCatalogV2" {
 rest_api_id   = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id   = aws_api_gateway_resource.CatalogAPIResourceV2.id
 http_method   = "GET"
 authorization = "NONE"
}
 
resource "aws_api_gateway_integration" "CatalogIntegrationV2" {
 rest_api_id             = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id             = aws_api_gateway_resource.CatalogAPIResourceV2.id
 http_method             = aws_api_gateway_method.ListCatalogV2.http_method
 type                    = "AWS_PROXY"
 integration_http_method = "POST"
 uri                     = aws_lambda_function.lambdav2.invoke_arn
}
 
resource "aws_lambda_permission" "apigw_lambdav2" {
 statement_id  = "AllowExecutionFromAPIGateway"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.lambdav2.function_name
 principal     = "apigateway.amazonaws.com"
 
 # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
 #source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.CatalogAPI.id}/*/${aws_api_gateway_method.ListCatalogV2.http_method}${aws_api_gateway_resource.CatalogAPIResourceV2.path}"
 source_arn = "${aws_api_gateway_rest_api.CatalogAPI.execution_arn}/*/*" #FIXME
}

resource "aws_lambda_function" "lambdav2" {
 filename      = "lambdav2.zip"
 function_name = "lambdav2"
 role          = aws_iam_role.role.arn
 handler       = "lambdav2.handler"
 runtime       = "nodejs16.x"
 
 source_code_hash = filebase64sha256("lambdav2.zip")
}