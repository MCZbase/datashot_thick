CREATE OR REPLACE TRIGGER LEPIDOPTERA.SPEC_TIMESTAMP
BEFORE INSERT ON SPECIMEN
FOR EACH ROW
BEGIN
    SELECT SYSTIMESTAMP INTO :NEW.DATECREATED FROM Dual ;
END ;

ALTER TRIGGER LEPIDOPTERA.TRG_SPECIMEN_TIMESTAMP ENABLE;

ALTER TABLE LEPIDOPTERA.SPECIMEN
  ADD
  CONSTRAINT BARCODE_UNIQUE   
  UNIQUE (BARCODE);

CREATE OR REPLACE TRIGGER LEPIDOPTERA.TRG_SPECIMENID
BEFORE INSERT OR UPDATE ON SPECIMEN
FOR EACH ROW
DECLARE
    iCounter SPECIMEN.SpecimenId%TYPE;
    cannot_change_counter EXCEPTION;
BEGIN
    IF INSERTING THEN
      IF :NEW.SpecimenId is null THEN
        SELECT SEQ_SpecimenId.NEXTVAL INTO iCounter FROM Dual;
        :NEW.SpecimenId := iCounter;
       END IF;
    END IF;
    IF UPDATING THEN
        IF NOT (:NEW.SpecimenId = :OLD.SpecimenId) THEN
            RAISE cannot_change_counter;
        END IF;
    END IF;
EXCEPTION
     WHEN cannot_change_counter THEN
         RAISE_APPLICATION_ERROR(-20000, 'Cannot Change Counter Value');
END;

ALTER TRIGGER LEPIDOPTERA.TRG_SPECIMENID ENABLE; 
