<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Animal;
use Illuminate\Http\Request;
use App\Http\Requests\AnimalRequest;
use Illuminate\Database\QueryException;
use App\Http\Resources\Resources\AnimalResource;
use App\Http\Controllers\Messages\MessageController;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class AnimalController extends Controller
{
    private $message;

    public function __construct(){
        $this->message = new MessageController;
    }
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(AnimalRequest $request)
    {
        try {
            
            $validatedData = $request->validated();
            Animal::create($validatedData);
            return $this->message->succedRequest('Animal '.$this->message->handleException[0]);

        } catch (QueryException $e){

            return $this->message->errorRequest($this->message->handleException[5]);
    
        } catch (Exception $e) {
                
            return $this->message->errorRequest($this->message->handleException[6]);
             
        }    
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        try {

            $animal = Animal::findOrFail($id);
            $animalData = new AnimalResource($animal);
            return $this->message->succedRequestWithData($animalData);

            } catch (ModelNotFoundException $e) {

                return $this->message->failedRequest('Animal ID'.$this->message->handleException[4]);

            } catch (QueryException $e) {
                
               
                return $this->message->errorRequest($this->message->handleException[5]);

    
            } catch (Exception $e) {
    
                return $this->message->errorRequest($this->message->handleException[6]);

            }      
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(AnimalRequest $request,$id)
    {
        try {
           
            $validatedData =  $request->only(array_keys($request->rules()));
            $animal = Animal::findOrFail($id);
            $animal->update($validatedData);

            return $this->message->succedRequest('Animal '.$this->message->handleException[1]);

        } catch (ModelNotFoundException $e) {
            
                return $this->message->failedRequest('Animal ID'.$this->message->handleException[4]);

            } catch (QueryException $e) {
                
                
                return $this->message->errorRequest($this->message->handleException[5]);

    
            } catch (Exception $e) {
                 
                return $this->message->errorRequest($this->message->handleException[6]);

            }    
    
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {

            $animal = Animal::findOrFail($id);
            $animal->delete();
            return $this->message->succedRequest('Animal'. $this->message->handleException[2]);

        } catch (ModelNotFoundException $e) {

            return $this->message->failedRequest('Animal ID'.$this->message->handleException[4]);

        } catch (QueryException $e) {

            
            return $this->message->errorRequest($this->message->handleException[5]);


        } catch (Exception $e) {  

            return $this->message->errorRequest($this->message->handleException[6]);

        }  
    }

    /**
     * Restrore the specified resource from storage.
     */
    public function restore($id){
        try {

            $animal = Animal::onlyTrashed()->findOrFail($id);
            $animal->restore();
            return $this->message->succedRequest('Animal'.$this->message->handleException[3]);

        } catch (ModelNotFoundException $e){

            return $this->message->failedRequest('Animal ID'.$this->message->handleException[4]);

        }catch (QueryException $e) {

            return $this->message->errorRequest($this->message->handleException[5]);


        } catch (Exception $e) { 
 
            return $this->message->errorRequest($this->message->handleException[6]);

        }  

    }
}
