<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Http\Requests\StoreEventRequest;
use App\Http\Requests\UpdateEventRequest;
use App\Http\Resources\Resources\EventResource;
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
            $request->validate([
                'user_id' => 'required|exists:users,id',
                'animal_id' => 'nullable|exists:animals,id',
                'titre' => 'required|string',
                'description' => 'required|string|max:255',
                'dateEvent' => 'required|date',
                'heureDebut' => 'required|date_format:H:i',
                'heureFin' => 'required|date_format:H:i',
            ]);

            $event = Event::create([
                'user_id' => $request->user_id,
                'animal_id' => $request->animal_id ? $request->animal_id : null,
                'titre' => $request->titre,
                'description' => $request->description,
                'dateEvent' => $request->dateEvent,
                'heureDebut' => $request->heureDebut,
                'heureFin' => $request->heureFin,
            ]);

            return response()->json([
                'message' => 'Evénement ajouté avec succès !',
                'event' => $event,
            ]);

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

            $event->update([
                'user_id' => $request->user_id,
                'animal_id' => $request->animal_id ? $request->animal_id : null,
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
            return response()->json(['error' => $e->getMessage()], 404);
        } catch (Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
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
