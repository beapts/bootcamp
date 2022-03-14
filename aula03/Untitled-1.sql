--------------------------------------------------------
--  DDL for Table ERP_SKU_ALL
--------------------------------------------------------

  CREATE TABLE "GTP"."ERP_SKU_ALL" 
   (	"ID_COMPANY_FK" NUMBER(22,0), 
	"COD_ITEM_PK" VARCHAR2(255 BYTE), 
	"COD_ESTAB_PK" VARCHAR2(255 BYTE), 
	"DESC_ITEM" VARCHAR2(2000 BYTE), 
	"VAL_UNIT" FLOAT(126), 
	"YN_PARENT" CHAR(1 BYTE), 
	"COD_ITEM_PARENT" VARCHAR2(255 BYTE), 
	"COD_STD_UNIT" VARCHAR2(30 BYTE), 
	"DESC_STD_UNIT" VARCHAR2(255 BYTE), 
	"QTY_MULT_ORDER" FLOAT(126), 
	"COD_ORDER_UNIT" VARCHAR2(30 BYTE), 
	"DESC_ORDER_UNIT" VARCHAR2(255 BYTE), 
	"DATE_CREATED" DATE, 
	"COD_GROUP2" VARCHAR2(255 BYTE), 
	"COD_GROUP3" VARCHAR2(255 BYTE), 
	"COD_GROUP4" VARCHAR2(255 BYTE), 
	"COD_GROUP5" VARCHAR2(255 BYTE), 
	"COD_GROUP6" VARCHAR2(255 BYTE), 
	"COD_GROUP7" VARCHAR2(255 BYTE), 
	"COD_GROUP8" VARCHAR2(255 BYTE), 
	"COD_GROUP9" VARCHAR2(255 BYTE), 
	"COD_GROUP10" VARCHAR2(255 BYTE), 
	"COD_GROUP11" VARCHAR2(255 BYTE), 
	"COD_GROUP12" VARCHAR2(255 BYTE), 
	"DESC_GROUP1" VARCHAR2(400 BYTE), 
	"DESC_GROUP2" VARCHAR2(400 BYTE), 
	"DESC_GROUP3" VARCHAR2(400 BYTE), 
	"DESC_GROUP4" VARCHAR2(400 BYTE), 
	"DESC_GROUP5" VARCHAR2(400 BYTE), 
	"DESC_GROUP6" VARCHAR2(400 BYTE), 
	"DESC_GROUP7" VARCHAR2(400 BYTE), 
	"DESC_GROUP8" VARCHAR2(400 BYTE), 
	"DESC_GROUP9" VARCHAR2(400 BYTE), 
	"DESC_GROUP10" VARCHAR2(400 BYTE), 
	"DESC_GROUP11" VARCHAR2(400 BYTE), 
	"DESC_GROUP12" VARCHAR2(400 BYTE), 
	"DATE_INSERTED" DATE DEFAULT SYSDATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "GTP" ;
--------------------------------------------------------
--  DDL for Index ERP_SKU_ALL
--------------------------------------------------------

  CREATE UNIQUE INDEX "GTP"."ERP_SKU_ALL" ON "GTP"."ERP_SKU_ALL" ("COD_ITEM_PK", "COD_ESTAB_PK") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "GTP" ;
--------------------------------------------------------
--  DDL for Trigger TR_ERP_SKU_ALL
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "GTP"."TR_ERP_SKU_ALL" 
AFTER  INSERT  OR UPDATE  OR DELETE  ON ERP_SKU_ALL 
REFERENCING 
 NEW AS NEW
 OLD AS OLD
FOR EACH ROW
declare
   procedure alter_trigger (do varchar2)
   as pragma autonomous_transaction;
   begin  execute immediate do;end;

BEGIN


IF deleting THEN

    INSERT INTO wes_pending VALUES(SEQ_ID_WES.nextval ,'ERP_SKU_ALL', 'DELETE',1,:old.id_company_fk,:old.cod_item_pk
    ,:old.cod_estab_pk,null,null,null,null,null,current_date);

END IF;

IF inserting OR updating THEN

    INSERT INTO wes_pending VALUES(SEQ_ID_WES.nextval ,'ERP_SKU_ALL', 'INSERT',1,:new.id_company_fk,:new.cod_item_pk
    ,:new.cod_estab_pk,null,null,null,null,null,current_date);

END IF;


IF updating THEN

    IF :old.cod_std_unit != :new.cod_std_unit THEN

		--desabilitamos as triggers de movimento para nÃ£o gerarmos registros de delete na wes pending..
		--so iremos gerar inserts, mesmo porque registros de insert vem antecedidos de delete no iweb

        alter_trigger('ALTER TRIGGER TR_ERP_TRANSACTION_IN 	      DISABLE');
        alter_trigger('ALTER TRIGGER TR_ERP_TRANSACTION_OUT_MONTH DISABLE');
        alter_trigger('ALTER TRIGGER TR_ERP_TRANSACTION_OUT_DAY   DISABLE');

        DELETE FROM erp_transaction_in 		  WHERE id_company_fk = :new.id_company_fk AND cod_item = :new.cod_item_pk AND cod_estab = :new.cod_estab_pk;
		DELETE FROM erp_transaction_out_month WHERE id_company_fk = :new.id_company_fk AND cod_item_pk = :new.cod_item_pk AND cod_estab_pk = :new.cod_estab_pk;
		DELETE FROM erp_transaction_out_day   WHERE id_company_fk = :new.id_company_fk AND cod_item_pk = :new.cod_item_pk AND cod_estab_pk = :new.cod_estab_pk;

        alter_trigger('ALTER TRIGGER TR_ERP_TRANSACTION_IN 	      ENABLE');
        alter_trigger('ALTER TRIGGER TR_ERP_TRANSACTION_OUT_MONTH ENABLE');
        alter_trigger('ALTER TRIGGER TR_ERP_TRANSACTION_OUT_DAY   ENABLE');

		-- Gera inserts de longos periodos
        INSERT INTO erp_transaction_in
            SELECT :new.id_company_fk,t.* FROM vw_erp_transaction_in t
			WHERE cod_item = :new.cod_item_pk AND cod_estab = :new.cod_estab_pk AND date_trans > current_date - 180;

        INSERT INTO erp_transaction_out_month
            SELECT :new.id_company_fk,t.* FROM vw_erp_transaction_out_month t
			WHERE cod_item_pk = :new.cod_item_pk AND cod_estab_pk = :new.cod_estab_pk AND month_trans_pk between current_date - 365*3 and current_date -30 ;

        INSERT INTO erp_transaction_out_day
            SELECT :new.id_company_fk,t.* FROM vw_erp_transaction_out_day t
			WHERE cod_item_pk = :new.cod_item_pk AND cod_estab_pk = :new.cod_estab_pk AND date_trans_pk between current_date - 180 and current_date ;

   END IF;
END IF;
end;
/
ALTER TRIGGER "GTP"."TR_ERP_SKU_ALL" ENABLE;
--------------------------------------------------------
--  Constraints for Table ERP_SKU_ALL
--------------------------------------------------------

  ALTER TABLE "GTP"."ERP_SKU_ALL" ADD CONSTRAINT "ERP_SKU_ALL_PK" PRIMARY KEY ("COD_ITEM_PK", "COD_ESTAB_PK")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "GTP"  ENABLE;
  ALTER TABLE "GTP"."ERP_SKU_ALL" MODIFY ("COD_ESTAB_PK" NOT NULL ENABLE);
  ALTER TABLE "GTP"."ERP_SKU_ALL" MODIFY ("COD_ITEM_PK" NOT NULL ENABLE);
  ALTER TABLE "GTP"."ERP_SKU_ALL" MODIFY ("ID_COMPANY_FK" NOT NULL ENABLE);
