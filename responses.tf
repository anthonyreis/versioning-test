resource "aws_api_gateway_method_response" "response_200" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = "200"
}
 
resource "aws_api_gateway_method_response" "response_404" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = "404"
}

resource "aws_api_gateway_method_response" "response_500" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = "500"
}
 
resource "aws_api_gateway_method_response" "response_403" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = "403"
}

resource "aws_api_gateway_method_response" "response_400" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = "400"
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = aws_api_gateway_method_response.response_200.status_code
 selection_pattern = aws_api_gateway_method_response.response_200.status_code

  depends_on = [
   aws_api_gateway_method_response.response_200
 ]
}

resource "aws_api_gateway_integration_response" "integration_response_404" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = aws_api_gateway_method_response.response_404.status_code
 selection_pattern = aws_api_gateway_method_response.response_404.status_code

  depends_on = [
   aws_api_gateway_method_response.response_404
 ]
}

resource "aws_api_gateway_integration_response" "integration_response_500" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = aws_api_gateway_method_response.response_500.status_code
 selection_pattern = aws_api_gateway_method_response.response_500.status_code

  depends_on = [
   aws_api_gateway_method_response.response_500
 ]
}

resource "aws_api_gateway_integration_response" "integration_response_403" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = aws_api_gateway_method_response.response_403.status_code
 selection_pattern = aws_api_gateway_method_response.response_403.status_code

  depends_on = [
   aws_api_gateway_method_response.response_403
 ]
}

resource "aws_api_gateway_integration_response" "integration_response_400" {
 rest_api_id = aws_api_gateway_rest_api.CatalogAPI.id
 resource_id = aws_api_gateway_resource.CatalogAPIResource.id
 http_method = aws_api_gateway_method.ListCatalog.http_method
 status_code = aws_api_gateway_method_response.response_400.status_code
 selection_pattern = aws_api_gateway_method_response.response_400.status_code

 depends_on = [
   aws_api_gateway_method_response.response_400
 ]
}