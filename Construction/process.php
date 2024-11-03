<?php

	//Set your email id
    $to = "deepakchandra076@gmail.com";
	//end
    $name = $_REQUEST['name'];
    $email = $_REQUEST['email'];
	$subject = $_REQUEST['subject'];
	$message = $_REQUEST['message'];
	

    $fields = array();
    $fields{"name"} = "name";
    $fields{"email"} = "email";
    $fields{"subject"} = "subject";
    $fields{"message"} = "message";
	
    $body = "Enquiry Form:\n\n"; foreach($fields as $a => $b){   $body .= sprintf("%20s: %s\n",$b,$_REQUEST[$a]); }

    $send = mail($to, $subject, $body, $headers);

?>
