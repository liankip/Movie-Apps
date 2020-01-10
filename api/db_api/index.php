<?php

header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: GET, POST, PATCH');
header('Content-type: application/json');

$conn    = mysqli_connect('localhost', 'root', '', 'db_movies');
$request = $_SERVER['REQUEST_METHOD'];

switch ($request) {
    case 'GET':
        $sql = "SELECT * FROM movie ORDER BY id DESC";
        $result = mysqli_query($conn, $sql);

        if (mysqli_num_rows($result) > 0) {
            echo json_encode(mysqli_fetch_all($result, MYSQLI_ASSOC), JSON_NUMERIC_CHECK);
            http_response_code(200);
            die();
        } else {
            http_response_code(400);
            die('404');
        }

        break;

    case 'POST':
        $name = $_POST['name'];
        $description = $_POST['description'];
        $image = $_POST['image'];
        $realImage = exif_read_data($image);
        file_put_contents($name, $realImage);

        if ($name == '') {
            http_response_code(400);
            die();
        } else {
            $sql = "INSERT INTO movie (name, description, image) VALUES ('$name', '$description', '$realImage') ";
            $result = mysqli_query($conn, $sql);
            http_response_code(200);
            die();
        }
        break;

    case 'PATCH':
        $id = $_GET['id'];

        $sql = "UPDATE movie SET `like` = 2 WHERE id = '$id'";
        $result = mysqli_query($conn, $sql);
        http_response_code(200);
        die();
        break;

    default:
        # code....
        break;
}
