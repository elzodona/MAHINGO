<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Http\Requests\StoreEventRequest;
use App\Http\Requests\UpdateEventRequest;
use App\Http\Resources\Resources\EventResource;
use App\Models\Animal;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Exception;

class EventController extends Controller
{
    /**
     * Affiche la liste des événements.
     */
    public function index()
    {
        try {
            $events = Event::all();
            return EventResource::collection($events);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération des événements'], 500);
        }
    }

    public function eventByUser($id)
    {
        try {
            $events = Event::where('user_id', $id)->get();
            return EventResource::collection($events);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération des événements'], 500);
        }
    }

    /**
     * Crée un nouvel événement.
     */
    public function store(Request $request)
    {
        try {
            $id = null;
            if ($request->animal_id) {
                $animal = Animal::where('name', $request->animal_id)->first();
                if ($animal) {
                    $id = $animal->id;
                }
            }

            $event = Event::create([
                'user_id' => $request->user_id,
                'animal_id' => $id,
                'titre' => $request->titre,
                'description' => $request->description,
                'dateEvent' => $request->dateEvent,
                'heureDebut' => $request->heureDebut,
                'heureFin' => $request->heureFin,
            ]);

            return response()->json([
                'message' => 'Événement ajouté avec succès !',
                'event' => $event,
            ], 201);

        } catch (Exception $e) {
            return response()->json([
                'error' => $e->getMessage(),
            ], 500);
        }
    }


    /**
     * Affiche un événement spécifique.
     */
    public function show(Request $request)
    {
        try {
            $event = Event::where('titre', $request->titre)->get();
            return EventResource::collection($event);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Événement non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la récupération de l\'événement'], 500);
        }
    }

    /**
     * Met à jour un événement.
     */
    public function update(Request $request, $id)
    {
        try {
            $event = Event::findOrFail($id);

            $name = null;
            if ($request->has('animal_id') && !empty($request->animal_id)) {
                $animal = Animal::where('name', $request->animal_id)->first();
                if ($animal) {
                    $name = $animal->id;
                } else {
                    return response()->json(['error' => 'Animal non trouvé'], 404);
                }
            }

            $event->update([
                'user_id' => $request->user_id,
                'animal_id' => $name,
                'titre' => $request->titre,
                'description' => $request->description,
                'dateEvent' => $request->dateEvent,
                'heureDebut' => $request->heureDebut,
                'heureFin' => $request->heureFin,
            ]);

            return response()->json([
                'message' => 'Evénement modifié avec succès !',
                'event' => $event
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Événement non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la mise à jour de l\'événement : ' . $e->getMessage()], 500);
        }
    }

    /**
     * Supprime un événement (soft delete).
     */
    public function destroy($id)
    {
        try {
            $event = Event::findOrFail($id);
            $event->delete();

            return response()->json([
                'message' => 'Evénement supprimé avec succès !'
            ]);
        } catch (ModelNotFoundException $e) {
            return response()->json(['error' => 'Événement non trouvé'], 404);
        } catch (Exception $e) {
            return response()->json(['error' => 'Erreur lors de la suppression de l\'événement'], 500);
        }
    }

}
