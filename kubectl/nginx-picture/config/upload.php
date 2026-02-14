<?php

if (!isset($_FILES['avatar'])) {
    die("No file uploaded");
}

// Check for upload errors
if ($_FILES['avatar']['error'] !== UPLOAD_ERR_OK) {
    $errors = [
        UPLOAD_ERR_INI_SIZE => "File exceeds upload_max_filesize",
        UPLOAD_ERR_FORM_SIZE => "File exceeds form MAX_FILE_SIZE",
        UPLOAD_ERR_PARTIAL => "File upload was incomplete",
        UPLOAD_ERR_NO_FILE => "No file uploaded",
        UPLOAD_ERR_NO_TMP_DIR => "Missing temporary folder",
        UPLOAD_ERR_CANT_WRITE => "Failed to write file to disk",
    ];
    $message = $errors[$_FILES['avatar']['error']] ?? "Unknown upload error";
    die("Upload error: " . $message);
}

$targetFile = "picture.jpg";  // The file you want to replace

// Try to move the uploaded file to overwrite picture.jpg
if (move_uploaded_file($_FILES['avatar']['tmp_name'], $targetFile)) {
    echo "Upload successful. <a href='index.html'>Go back</a>";
    sleep(3);
    header("Location: index.html");
    exit;
} else {
    echo "Error uploading file.";
}

?>
