# To create resource 
resource "aws_instance" "instance-name"{
    ami= "imadeid"
    ..
    ..
}


# To get value of resource
data "aws_ami" "amiID"{
    most_recent= true

    filter{
        name="name"
        values= [""]
    }

    filter{
        name= "virtualization-type"
        values = ["hvm"]
    }

    owners = ["Some value"]
}


# Print output
output "output_name"{
    description = "Description of output"
    value = data.aws_ami.amiID.id 
}


# Provider from where aws is provided in below the region mentioned
provider "aws"{
    region="us-east-1"

}

# Variables
variable AWS_REGION{
    default= "us-west-1"
}
provider "aws"{
    region= var.AWS_REGION
}
variable AMIs{
    type="map"
    default{
        us-west-1="some-image-1"
        us-west-2="some-image-2"
    }
}
variable REGION{
    default="us-west-1"
}
resource "aws_instance" "instance-name"{
    ami=var.AMIs[var.REGION]
}

# Copy file to remote with provisioner and connect and execute
resource "aws_instance" "instance-name"{
    ami=var.AMIs[var.REGION]
    tags={
        some="tag"
        some-other="tag-2"
    }
    provisioner "file" {
        source="file.sh"
        destination="/tmp/file.sh"
    }

    connection {
        type="ssh"
        user=var.webuser
        private_key=file("filepath")
        host=self.public_ip
    }

    provisioner "remote-exec" {

        inline=[
            "chmod +x /tmp/file.sh",
            "sudo /tmp/file.sh"
        ]
    }

    provisioner "local-exec"{
        command="echo ${self.public_ip} >> private-ip.txt"
    }
}


# s3 bucket to store tfstate file such that team can access
terraform{
    backend "s3"{
        bucket="name-of-bucket"
        key="path/of/s3/folder"
        region="region-of-s3-bucket"
    }
}