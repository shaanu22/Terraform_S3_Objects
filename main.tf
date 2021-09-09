provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"

}



#S3 Bucket Resource Block
resource "aws_s3_bucket" "mybucket" {
   bucket = "my-tf-test-s3-bucket"
   acl    = "private"

   versioning {
       enabled = true
     }

  tags   = {
    Name     = "My bucket"
   }
}



resource "aws_s3_bucket_object" "multiobject" {
   bucket = aws_s3_bucket.mybucket.id 
     for_each = fileset("/home/shaanu/my-terrafile1/test-file","*")
     key      = each.value
     source   = "/home/shaanu/my-terrafile1/test-file/${each.value}"

     #The filemd5() function is available in Terraform 0.11.12 and later
     #For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
     #etag = "${md5(file("path/to/file"))}"
    etag = filemd5("/home/shaanu/my-terrafile1/test-file/${each.value}")


     provisioner "local-exec" {
       command = "echo ${timestamp()} > /home/shaanu/my-terrafile1/test-file/test1.txt"
}

      provisioner "local-exec" {
       command = "echo ${timestamp()} > /home/shaanu/my-terrafile1/test-file/test2.txt"
}

}






