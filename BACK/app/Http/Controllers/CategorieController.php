<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Categorie;
use Illuminate\Http\Request;
use App\Http\Requests\CategorieRequest;
use Illuminate\Database\QueryException;
use App\Http\Resources\Resources\CategorieResource;
use App\Http\Controllers\Messages\MessageController;
use App\Http\Resources\Collections\CategorieCollection;
use App\Models\Animal;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class CategorieController extends Controller
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
        $categories = Categorie::all();
        return new CategorieCollection($categories);
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(CategorieRequest $request)
    {
        try {
            $validatedData = $request->validated();
            Categorie::create($validatedData);
            return $this->message->succedRequest('Category '.$this->message->handleException[0]);

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

            $categorie = Categorie::findOrFail($id);
            $categorieData = new CategorieResource($categorie);
            return $this->message->succedRequestWithData($categorieData);

            } catch (ModelNotFoundException $e) {

                return $this->message->failedRequest('Category ID'.$this->message->handleException[4]);

            } catch (QueryException $e) {

                return $this->message->errorRequest($this->message->handleException[5]);

            } catch (Exception $e) {

                return $this->message->errorRequest($this->message->handleException[6]);
            }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(CategorieRequest $request, $id)
    {
        try {

            $validatedData =  $request->only(array_keys($request->rules()));
            $categorie = Categorie::findOrFail($id);
            $categorie->update($validatedData);
            return $this->message->succedRequest('Category '.$this->message->handleException[1]);

        } catch (ModelNotFoundException $e) {

            return $this->message->failedRequest('Category ID'.$this->message->handleException[4]);
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

            $categorie = Categorie::findOrFail($id);
            $categorie->delete();
            return $this->message->succedRequest('Category '.$this->message->handleException[2]);

        } catch (ModelNotFoundException $e) {

            return $this->message->failedRequest('Category ID'.$this->message->handleException[4]);

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

            $categorie = Categorie::onlyTrashed()->findOrFail($id);
            $categorie->restore();
            return $this->message->succedRequest('Category '.$this->message->handleException[3]);

        } catch (ModelNotFoundException $e){

            return $this->message->failedRequest('Category ID'. $this->message->handleException[4]);

        }catch (QueryException $e) {

            return $this->message->errorRequest($this->message->handleException[5]);

        } catch (Exception $e) {

            return $this->message->errorRequest($this->message->handleException[6]);
        }

    }
}
