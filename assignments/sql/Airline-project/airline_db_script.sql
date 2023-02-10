-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema airline_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema airline_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `airline_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `airline_db` ;

-- -----------------------------------------------------
-- Table `airline_db`.`aircraftmanufacturer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`aircraftmanufacturer` (
  `aircraft_manufacturer_id` INT NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`aircraft_manufacturer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`aircraft`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`aircraft` (
  `aircraft_id` INT NOT NULL,
  `aircraft_manufacturer_id` INT NULL DEFAULT NULL,
  `model` VARCHAR(45) NULL DEFAULT NULL,
  `aircraftmanufacturer_aircraft_manufacturer_id` INT NOT NULL,
  PRIMARY KEY (`aircraft_id`),
  UNIQUE INDEX `model` (`model` ASC) VISIBLE,
  INDEX `fk_aircraft_aircraftmanufacturer1_idx` (`aircraftmanufacturer_aircraft_manufacturer_id` ASC) VISIBLE,
  CONSTRAINT `fk_aircraft_aircraftmanufacturer1`
    FOREIGN KEY (`aircraftmanufacturer_aircraft_manufacturer_id`)
    REFERENCES `airline_db`.`aircraftmanufacturer` (`aircraft_manufacturer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`aircraftinstance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`aircraftinstance` (
  `aircraft_instance_id` INT NOT NULL,
  `aircraft_id` INT NULL DEFAULT NULL,
  `aircraft_aircraft_id` INT NOT NULL,
  PRIMARY KEY (`aircraft_instance_id`),
  INDEX `fk_aircraftinstance_aircraft1_idx` (`aircraft_aircraft_id` ASC) VISIBLE,
  CONSTRAINT `fk_aircraftinstance_aircraft1`
    FOREIGN KEY (`aircraft_aircraft_id`)
    REFERENCES `airline_db`.`aircraft` (`aircraft_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`travelclass`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`travelclass` (
  `travel_class_id` INT NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`travel_class_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`aircraftseat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`aircraftseat` (
  `aircraft_id` INT NOT NULL,
  `seat_id` INT NOT NULL,
  `travel_class_id` INT NULL DEFAULT NULL,
  `travelclass_travel_class_id` INT NOT NULL,
  `aircraft_aircraft_id` INT NOT NULL,
  PRIMARY KEY (`aircraft_id`, `seat_id`, `aircraft_aircraft_id`),
  INDEX `fk_aircraftseat_travelclass1_idx` (`travelclass_travel_class_id` ASC) VISIBLE,
  INDEX `fk_aircraftseat_aircraft1_idx` (`aircraft_aircraft_id` ASC) VISIBLE,
  CONSTRAINT `fk_aircraftseat_travelclass1`
    FOREIGN KEY (`travelclass_travel_class_id`)
    REFERENCES `airline_db`.`travelclass` (`travel_class_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aircraftseat_aircraft1`
    FOREIGN KEY (`aircraft_aircraft_id`)
    REFERENCES `airline_db`.`aircraft` (`aircraft_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`country` (
  `iata_country_code` CHAR(2) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`iata_country_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`airport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`airport` (
  `iata_airport_code` CHAR(3) NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `city` VARCHAR(45) NULL DEFAULT NULL,
  `iata_country_code` CHAR(2) NULL DEFAULT NULL,
  `country_iata_country_code` CHAR(2) NOT NULL,
  PRIMARY KEY (`iata_airport_code`),
  INDEX `fk_airport_country1_idx` (`country_iata_country_code` ASC) VISIBLE,
  CONSTRAINT `fk_airport_country1`
    FOREIGN KEY (`country_iata_country_code`)
    REFERENCES `airline_db`.`country` (`iata_country_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`flightstatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`flightstatus` (
  `flight_status_id` INT NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`flight_status_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`flight`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`flight` (
  `flight_call` INT NOT NULL,
  `schedule_id` INT NULL DEFAULT NULL,
  `flight_status_id` INT NULL DEFAULT NULL,
  `flightstatus_flight_status_id` INT NOT NULL,
  PRIMARY KEY (`flight_call`),
  INDEX `fk_flight_flightstatus1_idx` (`flightstatus_flight_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_flight_flightstatus1`
    FOREIGN KEY (`flightstatus_flight_status_id`)
    REFERENCES `airline_db`.`flightstatus` (`flight_status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`flightseatprice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`flightseatprice` (
  `flight_call` INT NOT NULL,
  `aircraft_id` INT NOT NULL,
  `seat_id` INT NOT NULL,
  `price_used` DOUBLE NULL DEFAULT NULL,
  `aircraftseat_aircraft_id` INT NOT NULL,
  `aircraftseat_seat_id` INT NOT NULL,
  `flight_flight_call` INT NOT NULL,
  PRIMARY KEY (`flight_call`, `aircraft_id`, `seat_id`, `aircraftseat_aircraft_id`, `aircraftseat_seat_id`, `flight_flight_call`),
  INDEX `fk_flightseatprice_aircraftseat1_idx` (`aircraftseat_aircraft_id` ASC, `aircraftseat_seat_id` ASC) VISIBLE,
  INDEX `fk_flightseatprice_flight1_idx` (`flight_flight_call` ASC) VISIBLE,
  CONSTRAINT `fk_flightseatprice_aircraftseat1`
    FOREIGN KEY (`aircraftseat_aircraft_id` , `aircraftseat_seat_id`)
    REFERENCES `airline_db`.`aircraftseat` (`aircraft_id` , `seat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flightseatprice_flight1`
    FOREIGN KEY (`flight_flight_call`)
    REFERENCES `airline_db`.`flight` (`flight_call`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`client` (
  `client_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `last_name` VARCHAR(45) NULL DEFAULT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  `email` VARCHAR(45) NOT NULL,
  `passport` VARCHAR(45) NOT NULL,
  `iata_country_code` CHAR(2) NULL DEFAULT NULL,
  `country_iata_country_code` CHAR(2) NOT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `fk_client_country1_idx` (`country_iata_country_code` ASC) VISIBLE,
  CONSTRAINT `fk_client_country1`
    FOREIGN KEY (`country_iata_country_code`)
    REFERENCES `airline_db`.`country` (`iata_country_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`booking` (
  `client_id` INT NOT NULL,
  `flight_call` INT NOT NULL,
  `aircraft_id` INT NOT NULL,
  `seat_id` INT NOT NULL,
  `flightseatprice_flight_call` INT NOT NULL,
  `flightseatprice_aircraft_id` INT NOT NULL,
  `flightseatprice_seat_id` INT NOT NULL,
  `client_client_id` INT NOT NULL,
  PRIMARY KEY (`client_id`, `flight_call`, `aircraft_id`, `seat_id`, `flightseatprice_flight_call`, `flightseatprice_aircraft_id`, `flightseatprice_seat_id`, `client_client_id`),
  INDEX `fk_booking_flightseatprice_idx` (`flightseatprice_flight_call` ASC, `flightseatprice_aircraft_id` ASC, `flightseatprice_seat_id` ASC) VISIBLE,
  INDEX `fk_booking_client1_idx` (`client_client_id` ASC) VISIBLE,
  CONSTRAINT `fk_booking_flightseatprice`
    FOREIGN KEY (`flightseatprice_flight_call` , `flightseatprice_aircraft_id` , `flightseatprice_seat_id`)
    REFERENCES `airline_db`.`flightseatprice` (`flight_call` , `aircraft_id` , `seat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_booking_client1`
    FOREIGN KEY (`client_client_id`)
    REFERENCES `airline_db`.`client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`direction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`direction` (
  `origin_iata_airport_code` CHAR(3) NOT NULL,
  `dest_iata_airport_code` CHAR(3) NOT NULL,
  `airport_iata_airport_code` CHAR(3) NOT NULL,
  `airport_iata_airport_code1` CHAR(3) NOT NULL,
  PRIMARY KEY (`origin_iata_airport_code`, `dest_iata_airport_code`, `airport_iata_airport_code`, `airport_iata_airport_code1`),
  INDEX `fk_direction_airport1_idx` (`airport_iata_airport_code` ASC) VISIBLE,
  INDEX `fk_direction_airport2_idx` (`airport_iata_airport_code1` ASC) VISIBLE,
  CONSTRAINT `fk_direction_airport1`
    FOREIGN KEY (`airport_iata_airport_code`)
    REFERENCES `airline_db`.`airport` (`iata_airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_direction_airport2`
    FOREIGN KEY (`airport_iata_airport_code1`)
    REFERENCES `airline_db`.`airport` (`iata_airport_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`flightaircraftinstance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`flightaircraftinstance` (
  `fight_call` INT NOT NULL,
  `aircraft_instance_id` INT NOT NULL,
  `aircraftinstance_aircraft_instance_id` INT NOT NULL,
  `flight_flight_call` INT NOT NULL,
  PRIMARY KEY (`fight_call`, `aircraft_instance_id`, `aircraftinstance_aircraft_instance_id`, `flight_flight_call`),
  INDEX `fk_flightaircraftinstance_aircraftinstance1_idx` (`aircraftinstance_aircraft_instance_id` ASC) VISIBLE,
  INDEX `fk_flightaircraftinstance_flight1_idx` (`flight_flight_call` ASC) VISIBLE,
  CONSTRAINT `fk_flightaircraftinstance_aircraftinstance1`
    FOREIGN KEY (`aircraftinstance_aircraft_instance_id`)
    REFERENCES `airline_db`.`aircraftinstance` (`aircraft_instance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flightaircraftinstance_flight1`
    FOREIGN KEY (`flight_flight_call`)
    REFERENCES `airline_db`.`flight` (`flight_call`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `airline_db`.`schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `airline_db`.`schedule` (
  `schedule_id` INT NOT NULL,
  `origin_iata_airport_code` CHAR(3) NULL DEFAULT NULL,
  `dest_iata_airport_code` CHAR(3) NULL DEFAULT NULL,
  `departure_time_gmt` TIMESTAMP NULL DEFAULT NULL,
  `arrival_time_gmt` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`schedule_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
