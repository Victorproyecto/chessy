<?php
// src/Controller/UserController.php
namespace App\Controller;

use App\Document\User;
use Doctrine\ODM\MongoDB\DocumentManager;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class UserController extends AbstractController
{
    #[Route('/user/create')]
    public function createUser(DocumentManager $dm): Response
    {
        $user = new User();
        $user->setName('Juan Perez');

        $dm->persist($user);
        $dm->flush();

        return new Response('Usuario creado con ID: ' . $user->getId());
    }
}
