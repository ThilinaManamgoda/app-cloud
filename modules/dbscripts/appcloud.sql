-- MySQL Script generated by MySQL Workbench
-- Mon Feb  1 17:54:10 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema AppCloudDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema AppCloudDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `AppCloudDB` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `AppCloudDB` ;

-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_APP_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_APP_TYPE` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(1000) NULL,
  `buildable` int(1) DEFAULT '1',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`AC_APP_TYPE`
-- -----------------------------------------------------
INSERT INTO `AC_APP_TYPE` (`id`, `name`, `description`) VALUES
(1, 'war', 'Allows you to create dynamic websites using Servlets and JSPs, instead of the static HTML webpages and JAX-RS/JAX-WS services.'),
(2, 'mss', 'WSO2 Microservices Framework for Java (WSO2 MSF4J) offers the best option to create microservices in Java using annotation-based programming model.'),
(3, 'php', 'Allows you to create dynamic web page content using PHP web applications.'),
(4, 'jaggery', 'Allows you to create dynamic web page content using Jaggery web applications.');


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_RUNTIME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_RUNTIME` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `repo_url` VARCHAR(250) NULL,
  `image_name` VARCHAR(100) NULL,
  `tag` VARCHAR(45) NOT NULL,
  `description` VARCHAR(1000) NULL,
  PRIMARY KEY (`id`, `name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationRuntime`
-- -----------------------------------------------------

INSERT INTO `AC_RUNTIME` (`id`, `name`, `repo_url`, `image_name`, `tag`, `description`) VALUES
(1, 'Apache Tomcat 8.0.28 / WSO2 Application Server 6.0.0-M1', 'registry.docker.appfactory.private.wso2.com:5000', 'wso2as', '6.0.0-m1', 'OS:Debian, JAVA Version:8u72'),
(2, 'OpenJDK 8', 'registry.docker.appfactory.private.wso2.com:5000', 'msf4j', '1.0', 'OS:Debian, JAVA Version:8u72'),
(3, 'Apache 2.4.10', 'registry.docker.appfactory.private.wso2.com:5000','php','5.6', 'OS:Debian, PHP Version:5.6.20'),
(4, 'Carbon 4.2.0', 'registry.docker.appfactory.private.wso2.com:5000','carbon','4.2.0', 'OS:Debian, Java Version:7u101'),
(5, 'Jaggery 0.11.0 ', 'registry.docker.appfactory.private.wso2.com:5000', 'jaggery', '0.11.0', 'OS:Debian, Java Version:7u101');



-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_APPLICATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_APPLICATION` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `hash_id` VARCHAR(24) NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  `default_version` varchar(24) DEFAULT NULL,
  `app_type_id` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT uk_Application_NAME_TID_REV UNIQUE(`name`, `tenant_id`),
  CONSTRAINT `fk_Application_ApplicationType1`
    FOREIGN KEY (`app_type_id`)
    REFERENCES `AppCloudDB`.`AC_APP_TYPE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_DEPLOYMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_DEPLOYMENT` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `replicas` INT NULL,
  `tenant_id` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_VERSION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_VERSION` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(13) NULL,
  `hash_id` VARCHAR(24) NULL,
  `application_id` INT NOT NULL,
  `runtime_id` INT NOT NULL,
  `status` VARCHAR(45) NULL,
  `deployment_id` INT NULL,
  `tenant_id` INT NULL,
  `con_spec_cpu` VARCHAR(10) NOT NULL,
  `con_spec_memory` VARCHAR(10) NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_white_listed` TINYINT unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_AC_VERSION_AC_APPLICATION1`
    FOREIGN KEY (`application_id`)
    REFERENCES `AppCloudDB`.`AC_APPLICATION` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AC_VERSION_ApplicationRuntime1`
    FOREIGN KEY (`runtime_id`)
    REFERENCES `AppCloudDB`.`AC_RUNTIME` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AC_VERSION_ApplicationDeployment1`
    FOREIGN KEY (`deployment_id`)
    REFERENCES `AppCloudDB`.`AC_DEPLOYMENT` (`id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;






-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_TAG`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_TAG` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `value` VARCHAR(100) NULL,
  `version_id` INT NOT NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_AC_TAG_AC_VERSION1`
    FOREIGN KEY (`version_id`)
    REFERENCES `AppCloudDB`.`AC_VERSION` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_RUNTIME_PROPERTY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_RUNTIME_PROPERTY` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `value` VARCHAR(100) NULL,
  `version_id` INT NOT NULL,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NOT NULL,
  `is_secured` BIT(1) NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_AC_RUNTIME_PROPERTY_AC_VERSION1`
    FOREIGN KEY (`version_id`)
    REFERENCES `AppCloudDB`.`AC_VERSION` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;





-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_TENANT_APP_TYPE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_TENANT_APP_TYPE` (
  `tenant_id` INT NOT NULL,
  `app_type_id` INT NOT NULL,
  CONSTRAINT `fk_TenantAppType_ApplicationType1`
    FOREIGN KEY (`app_type_id`)
    REFERENCES `AppCloudDB`.`AC_APP_TYPE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_APP_TYPE_RUNTIME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_APP_TYPE_RUNTIME` (
  `app_type_id` INT NOT NULL,
  `runtime_id` INT NOT NULL,
  CONSTRAINT `fk_ApplicationType_has_ApplicationRuntime_ApplicationType1`
    FOREIGN KEY (`app_type_id`)
    REFERENCES `AppCloudDB`.`AC_APP_TYPE` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ApplicationType_has_ApplicationRuntime_ApplicationRuntime1`
    FOREIGN KEY (`runtime_id`)
    REFERENCES `AppCloudDB`.`AC_RUNTIME` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationTypeRuntime`
-- -----------------------------------------------------
INSERT INTO `AC_APP_TYPE_RUNTIME` (`app_type_id`, `runtime_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 5);


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_TENANT_RUNTIME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_TENANT_RUNTIME` (
  `tenant_id` INT NOT NULL,
  `runtime_id` INT NOT NULL,
  CONSTRAINT `fk_TenanntRuntime_ApplicationRuntime1`
    FOREIGN KEY (`runtime_id`)
    REFERENCES `AppCloudDB`.`AC_RUNTIME` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_EVENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_EVENT` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `status` VARCHAR(45) NULL,
  `version_id` INT NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` VARCHAR(1000) NULL,
  `tenant_id` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_CONTAINER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_CONTAINER` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `version` VARCHAR(45) NULL,
  `deployment_id` INT NOT NULL,
  `tenant_id` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ApplicationContainer_ApplicationDeployment1`
    FOREIGN KEY (`deployment_id`)
    REFERENCES `AppCloudDB`.`AC_DEPLOYMENT` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_CONTAINER_SERVICE_PROXY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_CONTAINER_SERVICE_PROXY` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `protocol` VARCHAR(20) NULL,
  `port` INT NULL,
  `backend_port` VARCHAR(45) NULL,
  `container_id` INT NOT NULL,
  `tenant_id` INT NULL,
  `host_url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ApplicationServiceProxy_ApplicationContainer1`
    FOREIGN KEY (`container_id`)
    REFERENCES `AppCloudDB`.`AC_CONTAINER` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_APP_ICON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_APP_ICON` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `icon` MEDIUMBLOB DEFAULT NULL,
  `application_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `application_id_UNIQUE` (`application_id` ASC),
  CONSTRAINT `fk_AC_APPLICATION_ICON_AC_APPLICATION1`
    FOREIGN KEY (`application_id`)
    REFERENCES `AppCloudDB`.`AC_APPLICATION` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_TRANSPORT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_TRANSPORT` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `port` INT NOT NULL,
  `protocol` VARCHAR(4) NOT NULL,
  `service_prefix` VARCHAR(3) NOT NULL,
  `description` VARCHAR(1000) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `AppCloudDB`.`AC_RUNTIME_TRANSPORT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_RUNTIME_TRANSPORT` (
  `transport_id` INT NOT NULL,
  `runtime_id` INT NOT NULL,
  CONSTRAINT `fk_Service_id`
    FOREIGN KEY (`transport_id`)
    REFERENCES `AppCloudDB`.`AC_TRANSPORT` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ApplicationRuntime_id`
    FOREIGN KEY (`runtime_id`)
    REFERENCES `AppCloudDB`.`AC_RUNTIME` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AC_SUBSCRIPTION_PLANS (
    PLAN_ID	INTEGER NOT NULL AUTO_INCREMENT,
    PLAN_NAME   VARCHAR(200) NOT NULL,	
    MAX_APPLICATIONS	INT NOT NULL,
    PRIMARY KEY (PLAN_ID))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AC_CONTAINER_SPECIFICATIONS (
    CON_SPEC_ID     INTEGER NOT NULL AUTO_INCREMENT,
    CON_SPEC_NAME   VARCHAR(200) NOT NULL,
    CPU              INT NOT NULL,	
    MEMORY	     INT NOT NULL,
    COST_PER_HOUR    INT NOT NULL,
    PRIMARY KEY (CON_SPEC_ID))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AC_RUNTIME_CONTAINER_SPECIFICATIONS (
  id int(11) NOT NULL,
  CON_SPEC_ID int(11) NOT NULL,
  PRIMARY KEY (id,CON_SPEC_ID),
  KEY CON_SPEC_ID (CON_SPEC_ID))
ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `AppCloudDB`.`AC_WHITE_LISTED_TENANTS` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tenant_id` INT NOT NULL,
  `max_app_count` INT NOT NULL,
  PRIMARY KEY (`id`, `tenant_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationRuntime`
-- -----------------------------------------------------

INSERT INTO `AC_TRANSPORT` (`id`, `name`, `port`, `protocol`, `service_prefix`, `description`) VALUES
(1, 'http', 80, 'TCP', 'htp', 'HTTP Protocol'),
(2, 'https', 443, 'TCP', 'hts', 'HTTPS Protocol'),
(3, 'http-alt', 8080, 'TCP', 'htp', 'HTTP Alternate Protocol'),
(4, 'https-alt', 8443, 'TCP', 'hts', 'HTTPS Alternate Protocol'),
(5, 'http', 9763, 'TCP', 'htp', 'HTTP servlet transport for carbon products'),
(6, 'https', 9443, 'TCP', 'hts', 'HTTPS servlet transport for carbon products');

-- -----------------------------------------------------
-- Populate Data to `AppCloudDB`.`ApplicationRuntimeService`
-- -----------------------------------------------------
INSERT INTO `AC_RUNTIME_TRANSPORT` (`transport_id`, `runtime_id`) VALUES
(4, 1),
(4, 2),
(1, 3),
(4, 4),
(3, 1),
(3, 2),
(2, 3),
(3, 4),
(6, 5),
(5, 5);

INSERT INTO `AC_CONTAINER_SPECIFICATIONS` (`CON_SPEC_NAME`, `CPU`, `MEMORY`, `COST_PER_HOUR`) VALUES
('SMALL(128MB RAM and 0.1x vCPU)', 100, 128, 1),
('MEDIUM(256MB RAM and 0.2x vCPU)', 200, 256, 2),
('LARGE(512MB RAM and 0.3x vCPU)', 300, 512, 3);

INSERT INTO `AC_SUBSCRIPTION_PLANS` (`PLAN_NAME`, `MAX_APPLICATIONS`) VALUES
('FREE', 3),
('PAID', 10);

INSERT INTO `AC_RUNTIME_CONTAINER_SPECIFICATIONS` (`id`, `CON_SPEC_ID`) VALUES
(1, 3),
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(5, 3);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
