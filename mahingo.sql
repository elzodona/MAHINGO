-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 11 nov. 2024 à 13:39
-- Version du serveur : 10.4.27-MariaDB
-- Version de PHP : 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `mahingo`
--

-- --------------------------------------------------------

--
-- Structure de la table `animals`
--

CREATE TABLE `animals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `photo` longtext DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `date_birth` date NOT NULL,
  `sexe` enum('Male','Female') NOT NULL,
  `race` varchar(255) NOT NULL,
  `taille` double NOT NULL,
  `poids` double NOT NULL,
  `necklace_id` bigint(20) UNSIGNED DEFAULT NULL,
  `categorie_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `animals`
--

INSERT INTO `animals` (`id`, `photo`, `name`, `date_birth`, `sexe`, `race`, `taille`, `poids`, `necklace_id`, `categorie_id`, `user_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(3, NULL, 'Saloum saloum', '2024-11-11', 'Male', 'Ndama', 2.5, 90, 1, 1, 1, NULL, '2024-11-11 12:26:12', '2024-11-11 12:26:12'),
(4, NULL, 'Jemmy', '2024-11-11', 'Male', 'Ndama', 2, 90, 2, 1, 1, NULL, '2024-11-11 12:27:06', '2024-11-11 12:27:06'),
(5, NULL, 'Chaabane', '2024-11-11', 'Male', 'Ndama', 2, 90, 3, 1, 1, NULL, '2024-11-11 12:27:52', '2024-11-11 12:27:52'),
(6, NULL, 'Babs', '2024-11-11', 'Male', 'Ndama', 2, 90, 4, 2, 1, NULL, '2024-11-11 12:28:15', '2024-11-11 12:28:15'),
(7, NULL, 'Khabane', '2024-11-11', 'Male', 'Ndama', 2, 90, 5, 2, 1, NULL, '2024-11-11 12:28:30', '2024-11-11 12:28:30'),
(8, NULL, 'Dudu', '2024-11-11', 'Male', 'Ndama', 2, 90, 6, 2, 1, NULL, '2024-11-11 12:28:48', '2024-11-11 12:28:48'),
(9, NULL, 'Inoxtag', '2024-11-11', 'Male', 'Ndama', 2, 90, 7, 2, 1, NULL, '2024-11-11 12:29:26', '2024-11-11 12:29:26'),
(10, NULL, 'Michou', '2024-11-11', 'Male', 'Ndama', 2, 90, 8, 1, 1, NULL, '2024-11-11 12:29:47', '2024-11-11 12:29:47'),
(11, NULL, 'Houms', '2024-11-11', 'Female', 'Ndama', 2, 90, 9, 1, 1, NULL, '2024-11-11 12:30:10', '2024-11-11 12:30:10'),
(12, NULL, 'Kyaa', '2024-11-11', 'Female', 'Ndama', 2, 90, 10, 1, 1, NULL, '2024-11-11 12:30:32', '2024-11-11 12:30:32');

-- --------------------------------------------------------

--
-- Structure de la table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `libelle` varchar(255) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `libelle`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Vache', NULL, '2024-11-11 12:03:22', '2024-11-11 12:03:22'),
(2, 'Mouton', NULL, '2024-11-11 12:03:32', '2024-11-11 12:03:32');

-- --------------------------------------------------------

--
-- Structure de la table `events`
--

CREATE TABLE `events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `animal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `dateEvent` date NOT NULL,
  `heureDebut` time NOT NULL,
  `heureFin` time NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `events`
--

INSERT INTO `events` (`id`, `user_id`, `animal_id`, `titre`, `description`, `dateEvent`, `heureDebut`, `heureFin`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 'vaccination', 'Saisir la description', '2024-11-11', '12:55:00', '13:31:00', NULL, '2024-11-11 12:31:52', '2024-11-11 12:34:23'),
(2, 1, 5, 'reproduction', 'Saisir la description', '2024-11-11', '13:00:00', '12:32:00', NULL, '2024-11-11 12:32:18', '2024-11-11 12:34:38'),
(3, 1, 12, 'visite medicale', 'Saisir la description', '2024-11-11', '13:05:00', '12:32:00', NULL, '2024-11-11 12:34:10', '2024-11-11 12:34:10');

-- --------------------------------------------------------

--
-- Structure de la table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `health_notifs`
--

CREATE TABLE `health_notifs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `animal_id` bigint(20) UNSIGNED NOT NULL,
  `etat` enum('lu','non_lu') NOT NULL,
  `valeur` double NOT NULL,
  `type` varchar(255) NOT NULL,
  `dateSave` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `location_notifs`
--

CREATE TABLE `location_notifs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `animal_id` bigint(20) UNSIGNED NOT NULL,
  `etat` enum('lu','non_lu') NOT NULL,
  `dateSave` date NOT NULL,
  `altitude` double NOT NULL,
  `longitude` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `location_notifs`
--

INSERT INTO `location_notifs` (`id`, `user_id`, `animal_id`, `etat`, `dateSave`, `altitude`, `longitude`, `created_at`, `updated_at`) VALUES
(1, 1, 6, 'lu', '2024-10-30', 14.698, -17.446, '2024-11-11 12:35:34', '2024-11-11 12:35:57'),
(2, 1, 7, 'lu', '2024-10-30', 14.6995, -17.448, '2024-11-11 12:35:35', '2024-11-11 12:35:44'),
(3, 1, 8, 'non_lu', '2024-10-30', 14.7, -17.449, '2024-11-11 12:35:35', '2024-11-11 12:35:35'),
(4, 1, 9, 'lu', '2024-10-30', 14.7005, -17.4495, '2024-11-11 12:35:35', '2024-11-11 12:35:49'),
(5, 1, 10, 'non_lu', '2024-10-30', 14.701, -17.45, '2024-11-11 12:35:36', '2024-11-11 12:35:36'),
(6, 1, 11, 'lu', '2024-10-30', 14.7015, -17.4505, '2024-11-11 12:35:36', '2024-11-11 12:35:47'),
(7, 1, 12, 'non_lu', '2024-10-30', 14.702, -17.451, '2024-11-11 12:35:36', '2024-11-11 12:35:36');

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2024_08_30_225915_create_personal_access_tokens_table', 1),
(5, '2024_08_31_152854_create_necklaces_table', 1),
(6, '2024_09_01_024138_create_categories_table', 1),
(7, '2024_09_02_141953_create_animals_table', 1),
(8, '2024_09_23_165020_update_necklace_nullable_in_animals_table', 1),
(9, '2024_09_23_170101_change_taille_type_in_animals_table', 1),
(10, '2024_09_23_170510_change_poids_type_in_animals_table', 1),
(11, '2024_10_09_182131_create_events_table', 1),
(12, '2024_10_09_191753_make_id_animal_nullable_in_events_table', 1),
(13, '2024_10_15_110401_create_notifications_table', 1),
(14, '2024_10_15_154510_make_id_animal_nullable_in_notifications_table', 1),
(15, '2024_10_29_135506_create_location_notifs_table', 1),
(16, '2024_10_31_152632_create_health_notifs_table', 1),
(17, '2024_10_31_160431_add_date_save_to_health_notifs', 1);

-- --------------------------------------------------------

--
-- Structure de la table `necklaces`
--

CREATE TABLE `necklaces` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `photo` longtext DEFAULT NULL,
  `enabled_at` date DEFAULT NULL,
  `desabled_at` date DEFAULT NULL,
  `battery` int(11) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `temperature` int(11) DEFAULT NULL,
  `heart_rate` int(11) DEFAULT NULL,
  `localisation` varchar(255) DEFAULT NULL,
  `etat` varchar(255) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `necklaces`
--

INSERT INTO `necklaces` (`id`, `identifier`, `photo`, `enabled_at`, `desabled_at`, `battery`, `position`, `temperature`, `heart_rate`, `localisation`, `etat`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'M001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:04:23', '2024-11-11 12:04:23'),
(2, 'M002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:04:37', '2024-11-11 12:04:37'),
(3, 'M003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:04:47', '2024-11-11 12:04:47'),
(4, 'V002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:05:01', '2024-11-11 12:05:01'),
(5, 'V003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:05:12', '2024-11-11 12:05:12'),
(6, 'V001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:05:20', '2024-11-11 12:05:20'),
(7, 'V004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:05:30', '2024-11-11 12:05:30'),
(8, 'M004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:05:51', '2024-11-11 12:05:51'),
(9, 'M005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:06:07', '2024-11-11 12:06:07'),
(10, 'M006', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-11-11 12:06:20', '2024-11-11 12:06:20');

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `animal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `etat` enum('lu','non_lu') NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `dateEvent` date NOT NULL,
  `heureDebut` time NOT NULL,
  `heureFin` time NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `animal_id`, `etat`, `titre`, `description`, `dateEvent`, `heureDebut`, `heureFin`, `created_at`, `updated_at`) VALUES
(1, 1, 4, 'lu', 'vaccination', 'Saisir la description', '2024-11-11', '12:55:00', '13:31:00', '2024-11-11 12:35:32', '2024-11-11 12:36:08'),
(2, 1, 5, 'lu', 'reproduction', 'Saisir la description', '2024-11-11', '13:00:00', '12:32:00', '2024-11-11 12:35:33', '2024-11-11 12:36:03'),
(3, 1, 12, 'non_lu', 'visite medicale', 'Saisir la description', '2024-11-11', '13:05:00', '12:32:00', '2024-11-11 12:35:33', '2024-11-11 12:35:33');

-- --------------------------------------------------------

--
-- Structure de la table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '9ad253c6bf46faf37adca9d7ceb394557840621aef6a651b1b64d101e6aad3db', '[\"*\"]', NULL, NULL, '2024-11-11 12:07:06', '2024-11-11 12:07:06'),
(2, 'App\\Models\\User', 1, 'auth_token', '2e04f848bbf31daa10aa01970cae082cc09d437887d7a0899a49c73b0f497907', '[\"*\"]', NULL, NULL, '2024-11-11 12:25:49', '2024-11-11 12:25:49');

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `telephone` varchar(255) NOT NULL,
  `address` text NOT NULL,
  `profession` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('client','admin') NOT NULL DEFAULT 'client',
  `photo` longtext DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `telephone`, `address`, `profession`, `email`, `email_verified_at`, `password`, `role`, `photo`, `deleted_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Mugiwara', 'Ndao', '783845870', 'Grand Yoff', 'dev mobile', 'ndaoelhadji973@gmail.com', NULL, '$2y$12$LnbKEuK8wbakqVZl.fpO5.fqb7eNtcB5ppgqEQgMMfy8tmmwEpeuO', 'client', NULL, NULL, NULL, '2024-11-11 12:02:21', '2024-11-11 12:02:21');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `animals`
--
ALTER TABLE `animals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `animals_necklace_id_foreign` (`necklace_id`),
  ADD KEY `animals_categorie_id_foreign` (`categorie_id`),
  ADD KEY `animals_user_id_foreign` (`user_id`);

--
-- Index pour la table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Index pour la table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `events_user_id_foreign` (`user_id`),
  ADD KEY `events_animal_id_foreign` (`animal_id`);

--
-- Index pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Index pour la table `health_notifs`
--
ALTER TABLE `health_notifs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `health_notifs_user_id_foreign` (`user_id`),
  ADD KEY `health_notifs_animal_id_foreign` (`animal_id`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Index pour la table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `location_notifs`
--
ALTER TABLE `location_notifs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location_notifs_user_id_foreign` (`user_id`),
  ADD KEY `location_notifs_animal_id_foreign` (`animal_id`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `necklaces`
--
ALTER TABLE `necklaces`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`),
  ADD KEY `notifications_animal_id_foreign` (`animal_id`);

--
-- Index pour la table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Index pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Index pour la table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `animals`
--
ALTER TABLE `animals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `health_notifs`
--
ALTER TABLE `health_notifs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `location_notifs`
--
ALTER TABLE `location_notifs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `necklaces`
--
ALTER TABLE `necklaces`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `animals`
--
ALTER TABLE `animals`
  ADD CONSTRAINT `animals_categorie_id_foreign` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `animals_necklace_id_foreign` FOREIGN KEY (`necklace_id`) REFERENCES `necklaces` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `animals_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_animal_id_foreign` FOREIGN KEY (`animal_id`) REFERENCES `animals` (`id`),
  ADD CONSTRAINT `events_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `health_notifs`
--
ALTER TABLE `health_notifs`
  ADD CONSTRAINT `health_notifs_animal_id_foreign` FOREIGN KEY (`animal_id`) REFERENCES `animals` (`id`),
  ADD CONSTRAINT `health_notifs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `location_notifs`
--
ALTER TABLE `location_notifs`
  ADD CONSTRAINT `location_notifs_animal_id_foreign` FOREIGN KEY (`animal_id`) REFERENCES `animals` (`id`),
  ADD CONSTRAINT `location_notifs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_animal_id_foreign` FOREIGN KEY (`animal_id`) REFERENCES `animals` (`id`),
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
