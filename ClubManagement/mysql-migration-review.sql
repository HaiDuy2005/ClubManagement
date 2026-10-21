CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` varchar(150) NOT NULL,
    `ProductVersion` varchar(32) NOT NULL,
    PRIMARY KEY (`MigrationId`)
);

START TRANSACTION;
CREATE TABLE `Admins` (
    `Id` int NOT NULL AUTO_INCREMENT,
    `Username` longtext NOT NULL,
    `Password` longtext NOT NULL,
    PRIMARY KEY (`Id`)
);

CREATE TABLE `Clubs` (
    `ClubId` int NOT NULL AUTO_INCREMENT,
    `ClubName` longtext NOT NULL,
    `Description` longtext NOT NULL,
    `CreatedDate` datetime(6) NOT NULL,
    PRIMARY KEY (`ClubId`)
);

CREATE TABLE `Contacts` (
    `ContactId` int NOT NULL AUTO_INCREMENT,
    `Name` longtext NOT NULL,
    `Email` longtext NOT NULL,
    `Message` longtext NOT NULL,
    `IsAnonymous` tinyint(1) NOT NULL,
    `CreatedAt` datetime(6) NOT NULL,
    PRIMARY KEY (`ContactId`)
);

CREATE TABLE `MemberRegistrations` (
    `RegistrationId` int NOT NULL AUTO_INCREMENT,
    `FullName` longtext NOT NULL,
    `StudentCode` longtext NOT NULL,
    `ClassName` longtext NOT NULL,
    `Phone` longtext NOT NULL,
    `Email` longtext NOT NULL,
    `Reason` longtext NOT NULL,
    `Status` longtext NOT NULL,
    `CreatedAt` datetime(6) NOT NULL,
    PRIMARY KEY (`RegistrationId`)
);

CREATE TABLE `Activities` (
    `ActivityId` int NOT NULL AUTO_INCREMENT,
    `ActivityName` longtext NOT NULL,
    `Description` longtext NOT NULL,
    `Location` longtext NOT NULL,
    `ActivityDate` datetime(6) NOT NULL,
    `ClubId` int NOT NULL,
    PRIMARY KEY (`ActivityId`),
    CONSTRAINT `FK_Activities_Clubs_ClubId` FOREIGN KEY (`ClubId`) REFERENCES `Clubs` (`ClubId`) ON DELETE RESTRICT
);

CREATE TABLE `Members` (
    `MemberId` int NOT NULL AUTO_INCREMENT,
    `FullName` longtext NOT NULL,
    `StudentCode` longtext NOT NULL,
    `ClassName` longtext NOT NULL,
    `Email` longtext NOT NULL,
    `Phone` longtext NOT NULL,
    `Position` longtext NOT NULL,
    `TrainingPoints` int NOT NULL,
    `ClubId` int NOT NULL,
    PRIMARY KEY (`MemberId`),
    CONSTRAINT `FK_Members_Clubs_ClubId` FOREIGN KEY (`ClubId`) REFERENCES `Clubs` (`ClubId`) ON DELETE RESTRICT
);

CREATE TABLE `ActivityAttendances` (
    `AttendanceId` int NOT NULL AUTO_INCREMENT,
    `FullName` longtext NOT NULL,
    `StudentCode` longtext NOT NULL,
    `ClassName` longtext NOT NULL,
    `ActivityId` int NOT NULL,
    `AttendanceDate` datetime(6) NOT NULL,
    `EvidenceObjectKey` longtext NOT NULL,
    `EvidenceFileName` longtext NOT NULL,
    `Status` longtext NOT NULL,
    `TrainingPoints` int NOT NULL,
    `AdminNote` longtext NOT NULL,
    PRIMARY KEY (`AttendanceId`),
    CONSTRAINT `FK_ActivityAttendances_Activities_ActivityId` FOREIGN KEY (`ActivityId`) REFERENCES `Activities` (`ActivityId`) ON DELETE RESTRICT
);

CREATE TABLE `ActivityRegistrations` (
    `RegistrationId` int NOT NULL AUTO_INCREMENT,
    `FullName` longtext NOT NULL,
    `ClassName` longtext NOT NULL,
    `StudentCode` longtext NOT NULL,
    `Email` longtext NOT NULL,
    `ActivityId` int NOT NULL,
    `ActivityName` longtext NOT NULL,
    `ActivityDate` datetime(6) NOT NULL,
    `IsApproved` tinyint(1) NOT NULL,
    PRIMARY KEY (`RegistrationId`),
    CONSTRAINT `FK_ActivityRegistrations_Activities_ActivityId` FOREIGN KEY (`ActivityId`) REFERENCES `Activities` (`ActivityId`) ON DELETE RESTRICT
);

CREATE TABLE `FileStorages` (
    `FileId` int NOT NULL AUTO_INCREMENT,
    `FileName` longtext NOT NULL,
    `ObjectKey` longtext NOT NULL,
    `FileType` longtext NOT NULL,
    `FileSize` bigint NOT NULL,
    `UploadDate` datetime(6) NOT NULL,
    `ActivityId` int NOT NULL,
    PRIMARY KEY (`FileId`),
    CONSTRAINT `FK_FileStorages_Activities_ActivityId` FOREIGN KEY (`ActivityId`) REFERENCES `Activities` (`ActivityId`) ON DELETE RESTRICT
);

CREATE TABLE `Attendances` (
    `AttendanceId` int NOT NULL AUTO_INCREMENT,
    `MemberId` int NOT NULL,
    `ActivityId` int NOT NULL,
    `Status` tinyint(1) NOT NULL,
    PRIMARY KEY (`AttendanceId`),
    CONSTRAINT `FK_Attendances_Activities_ActivityId` FOREIGN KEY (`ActivityId`) REFERENCES `Activities` (`ActivityId`) ON DELETE RESTRICT,
    CONSTRAINT `FK_Attendances_Members_MemberId` FOREIGN KEY (`MemberId`) REFERENCES `Members` (`MemberId`) ON DELETE RESTRICT
);

CREATE INDEX `IX_Activities_ClubId` ON `Activities` (`ClubId`);

CREATE INDEX `IX_ActivityAttendances_ActivityId` ON `ActivityAttendances` (`ActivityId`);

CREATE INDEX `IX_ActivityRegistrations_ActivityId` ON `ActivityRegistrations` (`ActivityId`);

CREATE INDEX `IX_Attendances_ActivityId` ON `Attendances` (`ActivityId`);

CREATE INDEX `IX_Attendances_MemberId` ON `Attendances` (`MemberId`);

CREATE INDEX `IX_FileStorages_ActivityId` ON `FileStorages` (`ActivityId`);

CREATE INDEX `IX_Members_ClubId` ON `Members` (`ClubId`);

INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
VALUES ('20261019054046_InitialMySqlCreate', '10.0.12');

COMMIT;

