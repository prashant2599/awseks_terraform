resource "aws_key_pair" "myprojecteks"{
    key_name = "myprojecteks"
    public_key = file("../modules/key/ToDo-App.pub")
}