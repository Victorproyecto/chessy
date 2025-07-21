<?php
// src/Controller/UserController.php
namespace App\Controller;

use App\Document\User;
use Doctrine\ODM\MongoDB\DocumentManager;
use MongoDB\Client;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class UserController extends AbstractController
{
    #[Route('/user/create')]
    public function createUser(DocumentManager $dm): Response
    {
        dump($dm->getConfiguration()->getDefaultDB()); // Debería mostrar content_chess o lo que tengas en MONGODB_DB

        $user = new User();
        $user->setName('Vicddddtor Pesrez');

        try {
            $dm->persist($user);
            $dm->flush();
            return new Response('Usuario creado con ID: ' . $user->getId());
        } catch (\Exception $e) {
            return new Response('Error: ' . $e->getMessage());
        }
    }

    #[Route('/mongo-test')]
    public function mongoTest(): Response
    {
        $client = new Client($_ENV['MONGODB_URL']);
        $db = $client->selectDatabase($_ENV['MONGODB_DB']);
        $users = $db->User->find()->toArray();

        return new Response('Usuarios: ' . json_encode($users));
    }

}
