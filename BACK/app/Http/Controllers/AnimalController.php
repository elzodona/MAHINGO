<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Animal;
use Illuminate\Http\Request;
use App\Http\Requests\AnimalRequest;
use Illuminate\Database\QueryException;
use App\Http\Resources\Resources\AnimalResource;
use App\Http\Controllers\Messages\MessageController;
use App\Http\Resources\Collections\AnimalCollection;
use App\Models\Categorie;
use App\Models\Necklace;
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
    public function index()
    {
        $animaux = Animal::all();
        return AnimalResource::collection($animaux);
    }

    public function animalsByUser($userId)
    {
        $categories = Categorie::all();

        $result = [];

        foreach ($categories as $category) {
            $animaux = Animal::where('user_id', $userId)
                ->where('categorie_id', $category->id)
                ->get();

            if ($animaux->count() > 0) {
                $result[] = [
                    'id' => $category->id,
                    'libelle' => $category->libelle,
                    'animaux' => AnimalResource::collection($animaux),
                ];
            }
        }

        return response()->json(['data' => $result]);
    }

    public function animalsByUserb($userId)
    {
        $animaux = Animal::where('user_id', $userId)->get();

        return response()->json(['data' => AnimalResource::collection($animaux)]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $necklace_id = Necklace::where('identifier', $request->necklace_id)->first()->id;

            $animal = Animal::create([
                'photo' => $request->photo ?? null,
                'name' => $request->name,
                'date_birth' => $request->date_birth,
                'sexe' => $request->sexe,
                'race' => $request->race,
                'taille' => $request->taille,
                'poids' => $request->poids,
                'necklace_id' => $necklace_id,
                'categorie_id' => $request->categorie_id,
                'user_id' => $request->user_id
            ]);

            return response()->json([
                'message' => 'Animal ajouté avec succès !',
                'data' => $animal
            ], 201);
        } catch (Exception $e) {
            return response()->json([
                'error' => $e->getMessage(),
                'data_received' => $request->all()
            ], 500);
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
            // return $request;
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
            return response()->json([
                'message' => "Suppression effectuée avec succès !"
            ], 200);

        } catch (Exception $e) {
            return response()->json([
                'error' => $e->getMessage()
            ], 500);
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
