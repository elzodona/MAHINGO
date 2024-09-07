<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Necklace;
use Illuminate\Http\Request;
use App\Http\Requests\NecklaceRequest;
use Illuminate\Database\QueryException;
use App\Http\Resources\Resources\NecklaceResource;
use App\Http\Controllers\Messages\MessageController;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class NecklaceController extends Controller
{
    private $message;

    
    public function __construct(){
        $this->message = new MessageController;
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(NecklaceRequest $request)
    {
        try {
            
            $neckLaceData = $request->validated();
            Necklace::create($neckLaceData);
            return $this->message->succedRequest('Necklace '.$this->message->handleException[0]);

        } catch (QueryException $e){
                
            return $this->message->errorRequest($this->message->handleException[5]);
    
        } catch (Exception $e) {
                
            return $this->message->errorRequest($this->message->handleException[6]); 
        }    

    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {

            $necklace = Necklace::findOrFail($id);
            $necklaceData = new NecklaceResource($necklace);
            return $this->message->succedRequestWithData($necklaceData);

            } catch (ModelNotFoundException $e) {

                return $this->message->failedRequest('Necklace ID'.$this->message->handleException[4]);

            } catch (QueryException $e) {
                
                return $this->message->failedRequest($this->message->handleException[5]);
    
            } catch (Exception $e) {
                
                return $this->message->failedRequest($this->message->handleException[6]); 
            }    
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(NecklaceRequest $request, $id)
    {
        try {
           
            $validatedData =  $request->only(array_keys($request->rules()));
            $necklace = Necklace::findOrFail($id);
            $necklace->update($validatedData);
            return $this->message->succedRequest('Necklace '.$this->message->handleException[1]);

        } catch (ModelNotFoundException $e) {

            return $this->message->failedRequest('Necklace ID'.$this->message->handleException[4]);

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

            $necklace = Necklace::findOrFail($id);
            $necklace->delete();
            return $this->message->succedRequest('Necklace '.$this->message->handleException[2]);

        } catch (ModelNotFoundException $e) {

            return $this->message->failedRequest($this->message->handleException[4]);

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
            
            $necklace = Necklace::onlyTrashed()->findOrFail($id);
            $necklace->restore();
            return $this->message->succedRequest('necklace '.$this->message->handleException[2]);

        } catch (ModelNotFoundException $e){

            return $this->message->failedRequest('Necklace ID'.$this->message->handleException[4]);

        }catch (QueryException $e) {

            return $this->message->errorRequest($this->message->handleException[5]);

        } catch (Exception $e) { 

            return $this->message->errorRequest($this->message->handleException[6]); 
        }  

    }
}
