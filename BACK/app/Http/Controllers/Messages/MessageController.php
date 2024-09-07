<?php

namespace App\Http\Controllers\Messages;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    private $notFoundMessage;
    private $notFoundStatus;
    private $queryExceptionMessage;
    private $exceptionMessage ;
    private $statusException;
    public $handleException;


    public function  __construct(){
        $success = 'successfully';

        $this->handleException = [
            0 =>'created '.$success,
            1 =>'updated '.$success,
            2 =>'deleted '.$success,
            3 =>'restored '.$success,
            4 =>'Not found',
            5 =>'An error occured', 
            6 =>'An unexpected error occurred',
        ];
    }
    
    public function succedRequest($message)
    {
        $response = [
            'status'=> 200,
            'message'=> $message
        ];
        return response()->json($response);
    } 

    public function succedRequestWithData($data)
    {
        $response = [
            'status'=> 200,
            'data'=>$data,
        ];
        return response()->json($response);
    }

    public function failedRequest($message)
    {
        $response = [
            'status'=> 404,
            'message'=>$message,
        ];
        return response()->json($response);
    }

    public function errorRequest($message)
    {
        $response = [
            'status'=>500,
            'message'=>$message
        ];
        return response()->json($response);
    }

}
