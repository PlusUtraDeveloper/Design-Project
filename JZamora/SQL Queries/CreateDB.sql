
CREATE TABLE [Attendance_Record]
( 
	[Grade]              integer  NULL ,
	[No._of_School_Days] integer  NULL ,
	[No._of_School_Days_Absent] integer  NULL ,
	[Cause_of_Absence]   text  NULL ,
	[No._of_Times_Tardy] integer  NULL ,
	[Cause_of_Tardiness] text  NULL ,
	[No._of_School_Days_Present] integer  NULL ,
	[Student_Id]         integer  NOT NULL 
)
go

ALTER TABLE [Attendance_Record]
	ADD CONSTRAINT [XPKAttendance_Record] PRIMARY KEY  CLUSTERED ([Student_Id] ASC)
go

CREATE TABLE [Character]
( 
	[Honesty]            integer  NULL ,
	[Courtesy]           integer  NULL ,
	[Helpfulness_And_Cooperation] integer  NULL ,
	[Resourcefulness_and_Creativity] integer  NULL ,
	[Consideration_for_Others] integer  NULL ,
	[Sportsmanship]      integer  NULL ,
	[Obedience]          integer  NULL ,
	[Self_Reliance]      integer  NULL ,
	[Industry]           integer  NULL ,
	[Cleanliness_and_Orderliness] integer  NULL ,
	[Promtness_and_Punctuality] integer  NULL ,
	[Sense_of_Responsibility] integer  NULL ,
	[Love_of_God]        integer  NULL ,
	[Patriotism_and_Love_of_Country] integer  NULL ,
	[Student_Id]         integer  NOT NULL 
)
go

ALTER TABLE [Character]
	ADD CONSTRAINT [XPKCharacter] PRIMARY KEY  CLUSTERED ([Student_Id] ASC)
go

CREATE TABLE [Class]
( 
	[Section]            varchar(20)  NULL ,
	[Grade_Level]        integer  NULL ,
	[Student_Id]         integer  NOT NULL 
)
go

ALTER TABLE [Class]
	ADD CONSTRAINT [XPKClass] PRIMARY KEY  CLUSTERED ([Student_Id] ASC)
go

CREATE TABLE [Grade]
( 
	[English]            integer  NULL ,
	[Filipino]           integer  NULL ,
	[Math]               integer  NULL ,
	[Araling_Panlipunan] integer  NULL ,
	[EsP]                integer  NULL ,
	[Music]              integer  NULL ,
	[Art]                integer  NULL ,
	[PE]                 integer  NULL ,
	[Health]             integer  NULL ,
	[Mother_Tongue]      integer  NULL ,
	[Period]             integer  NULL ,
	[Grade_Level]        integer  NULL ,
	[School_Year]        datetime  NULL ,
	[Section]            varchar(20)  NULL ,
	[Student_Id]         integer  NOT NULL 
)
go

ALTER TABLE [Grade]
	ADD CONSTRAINT [XPKGrade] PRIMARY KEY  CLUSTERED ([Student_Id] ASC)
go

CREATE TABLE [Parent_Guardian]
( 
	[Id]                 integer  NOT NULL  IDENTITY ( 1,1 ) ,
	[Name]               varchar(20)  NULL ,
	[Address]            varchar(20)  NULL ,
	[Occupation]         varchar(20)  NULL ,
	[Student_Id]         integer  NOT NULL 
)
go

ALTER TABLE [Parent_Guardian]
	ADD CONSTRAINT [XPKParent_Guardian] PRIMARY KEY  CLUSTERED ([Id] ASC,[Student_Id] ASC)
go

CREATE TABLE [Student]
( 
	[Last_Name]          varchar(50)  NULL ,
	[First_Name]         varchar(50)  NULL ,
	[Student_Id]         integer  NOT NULL  IDENTITY ( 1,1 ) ,
	[Division]           varchar(50)  NULL ,
	[School]             varchar(50)  NULL ,
	[Sex]                binary  NULL ,
	[Date_of_Birth]      datetime  NULL ,
	[Place]              varchar(50)  NULL ,
	[Date_of_Entrance]   datetime  NULL ,
	[Middle_Initial]     varchar(5)  NULL 
)
go

ALTER TABLE [Student]
	ADD CONSTRAINT [XPKStudent] PRIMARY KEY  CLUSTERED ([Student_Id] ASC)
go

CREATE TABLE [TOR_Photo]
( 
	[Grade_Photo]        image  NULL ,
	[Student_Id]         integer  NOT NULL 
)
go

ALTER TABLE [TOR_Photo]
	ADD CONSTRAINT [XPKTOR_Photo] PRIMARY KEY  CLUSTERED ([Student_Id] ASC)
go


ALTER TABLE [Attendance_Record]
	ADD CONSTRAINT [R_6] FOREIGN KEY ([Student_Id]) REFERENCES [Student]([Student_Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Character]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([Student_Id]) REFERENCES [Student]([Student_Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Class]
	ADD CONSTRAINT [R_13] FOREIGN KEY ([Student_Id]) REFERENCES [Student]([Student_Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Grade]
	ADD CONSTRAINT [R_15] FOREIGN KEY ([Student_Id]) REFERENCES [Class]([Student_Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Parent_Guardian]
	ADD CONSTRAINT [R_17] FOREIGN KEY ([Student_Id]) REFERENCES [Student]([Student_Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [TOR_Photo]
	ADD CONSTRAINT [R_3] FOREIGN KEY ([Student_Id]) REFERENCES [Student]([Student_Id])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Attendance_Record ON Attendance_Record FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Attendance_Record */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Student  Attendance_Record on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00014ae6", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Attendance_Record"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="Student_Id" */
    IF EXISTS (SELECT * FROM deleted,Student
      WHERE
        /* %JoinFKPK(deleted,Student," = "," AND") */
        deleted.Student_Id = Student.Student_Id AND
        NOT EXISTS (
          SELECT * FROM Attendance_Record
          WHERE
            /* %JoinFKPK(Attendance_Record,Student," = "," AND") */
            Attendance_Record.Student_Id = Student.Student_Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Attendance_Record because Student exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Attendance_Record ON Attendance_Record FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Attendance_Record */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Student  Attendance_Record on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001678b", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Attendance_Record"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="Student_Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Student
        WHERE
          /* %JoinFKPK(inserted,Student) */
          inserted.Student_Id = Student.Student_Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Attendance_Record because Student does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Character ON Character FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Character */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Student  Character on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000149d4", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Character"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Student_Id" */
    IF EXISTS (SELECT * FROM deleted,Student
      WHERE
        /* %JoinFKPK(deleted,Student," = "," AND") */
        deleted.Student_Id = Student.Student_Id AND
        NOT EXISTS (
          SELECT * FROM Character
          WHERE
            /* %JoinFKPK(Character,Student," = "," AND") */
            Character.Student_Id = Student.Student_Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Character because Student exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Character ON Character FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Character */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Student  Character on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00016bb6", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Character"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Student_Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Student
        WHERE
          /* %JoinFKPK(inserted,Student) */
          inserted.Student_Id = Student.Student_Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Character because Student does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Class ON Class FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Class */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Class  Grade on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00021a7c", PARENT_OWNER="", PARENT_TABLE="Class"
    CHILD_OWNER="", CHILD_TABLE="Grade"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Student_Id" */
    IF EXISTS (
      SELECT * FROM deleted,Grade
      WHERE
        /*  %JoinFKPK(Grade,deleted," = "," AND") */
        Grade.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Class because Grade exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Student  Class on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Class"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Student_Id" */
    IF EXISTS (SELECT * FROM deleted,Student
      WHERE
        /* %JoinFKPK(deleted,Student," = "," AND") */
        deleted.Student_Id = Student.Student_Id AND
        NOT EXISTS (
          SELECT * FROM Class
          WHERE
            /* %JoinFKPK(Class,Student," = "," AND") */
            Class.Student_Id = Student.Student_Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Class because Student exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Class ON Class FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Class */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Class  Grade on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00026417", PARENT_OWNER="", PARENT_TABLE="Class"
    CHILD_OWNER="", CHILD_TABLE="Grade"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Student_Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Grade
      WHERE
        /*  %JoinFKPK(Grade,deleted," = "," AND") */
        Grade.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Class because Grade exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Student  Class on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Class"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Student_Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Student
        WHERE
          /* %JoinFKPK(inserted,Student) */
          inserted.Student_Id = Student.Student_Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Class because Student does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Grade ON Grade FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Grade */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Class  Grade on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001379c", PARENT_OWNER="", PARENT_TABLE="Class"
    CHILD_OWNER="", CHILD_TABLE="Grade"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Student_Id" */
    IF EXISTS (SELECT * FROM deleted,Class
      WHERE
        /* %JoinFKPK(deleted,Class," = "," AND") */
        deleted.Student_Id = Class.Student_Id AND
        NOT EXISTS (
          SELECT * FROM Grade
          WHERE
            /* %JoinFKPK(Grade,Class," = "," AND") */
            Grade.Student_Id = Class.Student_Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Grade because Class exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Grade ON Grade FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Grade */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Class  Grade on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00014d2b", PARENT_OWNER="", PARENT_TABLE="Class"
    CHILD_OWNER="", CHILD_TABLE="Grade"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="Student_Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Class
        WHERE
          /* %JoinFKPK(inserted,Class) */
          inserted.Student_Id = Class.Student_Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Grade because Class does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Parent_Guardian ON Parent_Guardian FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Parent_Guardian */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Student  Parent_Guardian on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000148d6", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Parent_Guardian"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Student_Id" */
    IF EXISTS (SELECT * FROM deleted,Student
      WHERE
        /* %JoinFKPK(deleted,Student," = "," AND") */
        deleted.Student_Id = Student.Student_Id AND
        NOT EXISTS (
          SELECT * FROM Parent_Guardian
          WHERE
            /* %JoinFKPK(Parent_Guardian,Student," = "," AND") */
            Parent_Guardian.Student_Id = Student.Student_Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Parent_Guardian because Student exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Parent_Guardian ON Parent_Guardian FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Parent_Guardian */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insId integer, 
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Student  Parent_Guardian on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00017611", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Parent_Guardian"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Student_Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Student
        WHERE
          /* %JoinFKPK(inserted,Student) */
          inserted.Student_Id = Student.Student_Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Parent_Guardian because Student does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Student ON Student FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Student */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Student  Parent_Guardian on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0004db09", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Parent_Guardian"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Student_Id" */
    IF EXISTS (
      SELECT * FROM deleted,Parent_Guardian
      WHERE
        /*  %JoinFKPK(Parent_Guardian,deleted," = "," AND") */
        Parent_Guardian.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Student because Parent_Guardian exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Student  Class on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Class"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Student_Id" */
    IF EXISTS (
      SELECT * FROM deleted,Class
      WHERE
        /*  %JoinFKPK(Class,deleted," = "," AND") */
        Class.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Student because Class exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Student  Attendance_Record on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Attendance_Record"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="Student_Id" */
    IF EXISTS (
      SELECT * FROM deleted,Attendance_Record
      WHERE
        /*  %JoinFKPK(Attendance_Record,deleted," = "," AND") */
        Attendance_Record.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Student because Attendance_Record exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Student  Character on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Character"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Student_Id" */
    IF EXISTS (
      SELECT * FROM deleted,Character
      WHERE
        /*  %JoinFKPK(Character,deleted," = "," AND") */
        Character.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Student because Character exists.'
      GOTO error
    END

    /* ERwin Builtin Trigger */
    /* Student  TOR_Photo on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="TOR_Photo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Student_Id" */
    IF EXISTS (
      SELECT * FROM deleted,TOR_Photo
      WHERE
        /*  %JoinFKPK(TOR_Photo,deleted," = "," AND") */
        TOR_Photo.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Student because TOR_Photo exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Student ON Student FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Student */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Student  Parent_Guardian on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0005571e", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Parent_Guardian"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="Student_Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Parent_Guardian
      WHERE
        /*  %JoinFKPK(Parent_Guardian,deleted," = "," AND") */
        Parent_Guardian.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Student because Parent_Guardian exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Student  Class on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Class"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="Student_Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Class
      WHERE
        /*  %JoinFKPK(Class,deleted," = "," AND") */
        Class.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Student because Class exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Student  Attendance_Record on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Attendance_Record"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="Student_Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Attendance_Record
      WHERE
        /*  %JoinFKPK(Attendance_Record,deleted," = "," AND") */
        Attendance_Record.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Student because Attendance_Record exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Student  Character on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="Character"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="Student_Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Character
      WHERE
        /*  %JoinFKPK(Character,deleted," = "," AND") */
        Character.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Student because Character exists.'
      GOTO error
    END
  END

  /* ERwin Builtin Trigger */
  /* Student  TOR_Photo on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="TOR_Photo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Student_Id" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,TOR_Photo
      WHERE
        /*  %JoinFKPK(TOR_Photo,deleted," = "," AND") */
        TOR_Photo.Student_Id = deleted.Student_Id
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Student because TOR_Photo exists.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_TOR_Photo ON TOR_Photo FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on TOR_Photo */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Student  TOR_Photo on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000148a8", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="TOR_Photo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Student_Id" */
    IF EXISTS (SELECT * FROM deleted,Student
      WHERE
        /* %JoinFKPK(deleted,Student," = "," AND") */
        deleted.Student_Id = Student.Student_Id AND
        NOT EXISTS (
          SELECT * FROM TOR_Photo
          WHERE
            /* %JoinFKPK(TOR_Photo,Student," = "," AND") */
            TOR_Photo.Student_Id = Student.Student_Id
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last TOR_Photo because Student exists.'
      GOTO error
    END


    /* ERwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_TOR_Photo ON TOR_Photo FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on TOR_Photo */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insStudent_Id integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* ERwin Builtin Trigger */
  /* Student  TOR_Photo on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00015883", PARENT_OWNER="", PARENT_TABLE="Student"
    CHILD_OWNER="", CHILD_TABLE="TOR_Photo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="Student_Id" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Student_Id)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Student
        WHERE
          /* %JoinFKPK(inserted,Student) */
          inserted.Student_Id = Student.Student_Id
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update TOR_Photo because Student does not exist.'
      GOTO error
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


