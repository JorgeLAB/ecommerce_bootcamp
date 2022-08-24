json.(product, :id, :name, :description)
json.price product.price.to_f
json.image_url rails_blob_url(product.image)
