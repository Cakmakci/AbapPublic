FUNCTION zubme_fg001_001.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      ET_TABLE_NAMES STRUCTURE  ZUBME_S001 OPTIONAL
*"      ET_T001 STRUCTURE  ZUBME_T001 OPTIONAL
*"      ET_T002 STRUCTURE  ZUBME_T002 OPTIONAL
*"      ET_T006 STRUCTURE  ZUBME_T006 OPTIONAL
*"      ET_T007 TYPE  ZUBPP_TT052 OPTIONAL
*"      ET_T005T STRUCTURE  ZUBME_S002 OPTIONAL
*"      ET_T003 STRUCTURE  ZUBME_T003 OPTIONAL
*"      ET_T008 STRUCTURE  ZUBME_T008 OPTIONAL
*"----------------------------------------------------------------------
  DEFINE add_table_names.
    APPEND VALUE #( name = &1 ) TO et_table_names.
  END-OF-DEFINITION.

  "ME Duruş Entegrasyonu
  SELECT * FROM zubme_t001 INTO TABLE et_t001.
  IF sy-subrc EQ 0.
    add_table_names 'ET_T001'.
  ENDIF.

  "ME Reason Code Additional Process
  SELECT * FROM zubme_t002 INTO TABLE et_t002.
  IF sy-subrc EQ 0.
    add_table_names 'ET_T002'.
  ENDIF.

  "Etiket okuma zaman kısıtı
  SELECT * FROM zubme_t006 INTO TABLE et_t006.
  IF sy-subrc EQ 0.
    add_table_names 'ET_T006'.
  ENDIF.

  "ME Hata Mesajları
  SELECT t002~laiso AS spras
         zubme_t005t~plant
         zubme_t005t~project_type
         zubme_t005t~process_code
         zubme_t005t~error_code
         zubme_t005t~error_code_text
         zubme_t005~type
    FROM zubme_t005t
    INNER JOIN zubme_t005
            ON zubme_t005~plant = zubme_t005t~plant
           AND zubme_t005~project_type = zubme_t005t~project_type
           AND zubme_t005~process_code = zubme_t005t~process_code
           AND zubme_t005~error_code = zubme_t005t~error_code
    INNER JOIN t002 ON t002~spras = zubme_t005t~spras
    INTO CORRESPONDING FIELDS OF TABLE et_t005t.
  IF sy-subrc EQ 0.
    add_table_names 'ET_T005T'.
    LOOP AT et_t005t ASSIGNING FIELD-SYMBOL(<fs_t005t>).
      TRANSLATE <fs_t005t>-spras TO LOWER CASE.
    ENDLOOP.
  ENDIF.


  "email uyarlama..
  PERFORM fill_email_customizing_table TABLES et_t007 et_t005t.
  IF et_t007[] IS NOT INITIAL.
    add_table_names 'ET_T007'.
  ENDIF.

  "Sortf detail
  SELECT * FROM zubme_t003
    INTO TABLE et_t003.
  IF et_t003[] IS NOT INITIAL.
    add_table_names 'ET_T003'.
  ENDIF.


  "Material Matching
  SELECT * FROM zubme_t008
    INTO TABLE et_t008.
  IF et_t008[] IS NOT INITIAL.
    add_table_names 'ET_T008'.
  ENDIF.


ENDFUNCTION.

FORM fill_email_customizing_table TABLES t_t007 TYPE zubpp_tt052
                                         t_t005t STRUCTURE zubme_s002.
  DATA : lv_spras TYPE spras,
         lt_lines TYPE TABLE OF tline.
  DATA : lv_index TYPE int4.

  SELECT * FROM zubme_t007 INTO TABLE @DATA(lt_t007).

  SELECT * FROM zubpp_t135 INTO TABLE @DATA(lt_t135).

  LOOP AT lt_t007 INTO DATA(ls_t007).
    READ TABLE lt_t135 INTO DATA(ls_t135)
      WITH KEY werks =  ls_t007-werks.

    lv_spras = COND #( WHEN sy-subrc NE 0 THEN 'TR' ELSE |{ ls_t135-spras }| ) .

    SELECT * FROM stxh INTO TABLE @DATA(lt_stxh)
      WHERE tdobject = 'TEXT'
        AND tdid = 'ST'
        AND tdname = @ls_t007-so10_text_name.
    IF sy-subrc = 0.

      IF NOT line_exists( lt_stxh[ tdspras = lv_spras ] ) .
        lv_spras = lt_stxh[ 1 ]-tdspras.
      ENDIF..

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'ST'
          language                = lv_spras
          name                    = ls_t007-so10_text_name
          object                  = 'TEXT'
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF lt_lines IS NOT INITIAL .
        DATA(lv_header) = lt_lines[ 1 ]-tdline.
        DELETE lt_lines INDEX 1.

        DATA(lv_mail_body) =  REDUCE text2048( INIT lv_value TYPE text2048
                                 FOR _lines IN  lt_lines[]
                                NEXT lv_value =  COND #( WHEN lv_value IS INITIAL THEN _lines-tdline ELSE | { lv_value } { cl_abap_char_utilities=>newline } { _lines-tdline } | ) )  .


        READ TABLE t_t005t INTO DATA(ls_t005t)
          WITH KEY spras = lv_spras
                   plant = ls_t007-werks
                   project_type = ls_t007-project_type
                   process_code = ls_t007-process_code
                   error_code   = ls_t007-error_code..
        IF sy-subrc = 0.
          REPLACE ALL OCCURRENCES OF 'ERP_P1' IN lv_mail_body WITH ls_t005t-error_code_text.
        ELSE.
          READ TABLE t_t005t INTO ls_t005t
            WITH KEY spras = lv_spras
                     plant = ls_t007-werks
                     project_type = 'COMMON'
                     process_code = ls_t007-process_code
                     error_code   = ls_t007-error_code..
          IF sy-subrc = 0.
            REPLACE ALL OCCURRENCES OF 'ERP_P1' IN lv_mail_body WITH ls_t005t-error_code_text.
          ENDIF.
        ENDIF.

      ELSE.
        CLEAR : lv_header ,lv_mail_body.
      ENDIF.

      APPEND VALUE zubpp_s102( werks          = ls_t007-werks
                               project_type   = ls_t007-project_type
                               process_code   = ls_t007-process_code
                               error_code     = ls_t007-error_code
                               from_to        = ls_t007-from_to
                               cc_receivers   = ls_t007-cc_receivers
                               rec_receivers  = ls_t007-rec_receivers
                               subject        = lv_header
                               mail_body      = lv_mail_body ) TO t_t007.

    ENDIF.
  ENDLOOP.

ENDFORM.
