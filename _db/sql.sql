-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  `user_cpf` VARCHAR(11) NOT NULL,
  `user_email` VARCHAR(155) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) ,
  UNIQUE INDEX `user_cpf_UNIQUE` (`user_cpf` ASC) ,
  UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Admin` (
  `admin_id` INT NOT NULL,
  `admin_hashPassword` VARCHAR(64) NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`admin_id`),
  INDEX `fk_Admin_User1_idx` (`user_id` ASC),
  FOREIGN KEY (`user_id`) REFERENCES User(`user_id`)
);


-- -----------------------------------------------------
-- Table `mydb`.`Vendor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Vendor` (
  `vendor_id` INT NOT NULL,
  `vendor_hasPassword` VARCHAR(45) NOT NULL,
  `admin_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`vendor_id`),
  INDEX `fk_Vendor_Admin1_idx` (`admin_id` ASC) ,
  INDEX `fk_Vendor_User1_idx` (`user_id` ASC),
  FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`),
	FOREIGN KEY (`admin_id`) REFERENCES `Admin`(`admin_id`)

 );


-- -----------------------------------------------------
-- Table `mydb`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Client` (
  `client_id` INT NOT NULL,
  `vendor_id` INT REFERENCES Vendor(vendor_id),
  `admin_id` INT REFERENCES Admin(admin_id),
  `user_id` INT NOT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `fk_Client_Vendor1_idx` (`vendor_id` ASC) ,
  INDEX `fk_Client_Admin1_idx` (`admin_id` ASC) ,
  INDEX `fk_Client_User1_idx` (`user_id` ASC),
  FOREIGN KEY (`vendor_id`) REFERENCES `Vendor`(`vendor_id`),
	FOREIGN KEY (`admin_id`) REFERENCES `Admin`(`admin_id`),
	FOREIGN KEY (`user_id`) REFERENCES `User`(`user_id`)
 );


-- -----------------------------------------------------
-- Table `mydb`.`Event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Event` (
  `event_id` INT NOT NULL AUTO_INCREMENT,
  `event_name` VARCHAR(45) NOT NULL,
  `event_data` VARCHAR(45) NOT NULL,
  `event_hora` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`event_id`),
  UNIQUE INDEX `event_id_UNIQUE` (`event_id` ASC) 
);


-- -----------------------------------------------------
-- Table `mydb`.`Ticket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ticket` (
  `ticket_id` INT NOT NULL,
  `emissao_data` DATE NOT NULL,
  `emissao_hora` VARCHAR(5) NOT NULL,
  `codigo` VARCHAR(64) NOT NULL,
  `client_id` INT NOT NULL,
  `vendor_id` INT,
  `admin_id` INT,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`ticket_id`),
  UNIQUE INDEX `ticket_id_UNIQUE` (`ticket_id` ASC) ,
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC) ,
  INDEX `fk_Ticket_Client1_idx` (`client_id` ASC) ,
  INDEX `fk_Ticket_Vendor1_idx` (`vendor_id` ASC) ,
  INDEX `fk_Ticket_Event1_idx` (`event_id` ASC) ,
  INDEX `fk_Ticket_Admin1_idx` (`admin_id` ASC),
  
  FOREIGN KEY (`vendor_id`) REFERENCES `Vendor`(`vendor_id`),
  FOREIGN KEY (`admin_id`) REFERENCES `Admin`(`admin_id`),
  FOREIGN KEY (`client_id`) REFERENCES `Client`(`client_id`),
  FOREIGN KEY (`event_id`) REFERENCES `Event`(`event_id`)
  
);


-- -----------------------------------------------------
-- Table `mydb`.`Setor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Setor` (
  `setor_id` INT NOT NULL AUTO_INCREMENT,
  `setor_nome` VARCHAR(45) NOT NULL,
  `qtde_disponivel` INT NOT NULL,
  `Event_event_id` INT NOT NULL,
  PRIMARY KEY (`setor_id`, `Event_event_id`),
  UNIQUE INDEX `event_id_UNIQUE` (`setor_id` ASC) ,
  INDEX `fk_Setor_Event1_idx` (`Event_event_id` ASC) ,
  CONSTRAINT `fk_Setor_Event1`
    FOREIGN KEY (`Event_event_id`)
    REFERENCES `mydb`.`Event` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    );

-- -----------------------------------------------------
-- Table `mydb`.`Cadeira`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Cadeira` (
  `cadeira_id` INT NOT NULL AUTO_INCREMENT,
  `cadeira_status` ENUM('Livre', 'Reservada', 'Ocupada') NOT NULL,
  `setor_id` INT NOT NULL,
  `ticket_id` INT NOT NULL,
  PRIMARY KEY (`cadeira_id`),
  UNIQUE INDEX `event_id_UNIQUE` (`cadeira_id` ASC) ,
  INDEX `fk_Cadeira_Setor1_idx` (`setor_id` ASC) ,
  INDEX `fk_Cadeira_Ticket1_idx` (`ticket_id` ASC),
  FOREIGN KEY (`setor_id`) REFERENCES `Setor`(`setor_id`),
	FOREIGN KEY (`ticket_id`) REFERENCES `Ticket`(`ticket_id`)
);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
