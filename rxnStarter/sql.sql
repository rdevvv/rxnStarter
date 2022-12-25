CREATE TABLE `rxn_starter` (
  `identifier` varchar(60) NOT NULL,
  `starter` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE `rxn_starter`
  ADD PRIMARY KEY (`identifier`);
COMMIT;