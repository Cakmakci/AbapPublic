class ZUBME_CL_DRF_MES_ROUTER definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_DRF_MES_ROUTER .
protected section.
private section.
ENDCLASS.



CLASS ZUBME_CL_DRF_MES_ROUTER IMPLEMENTATION.


  METHOD if_drf_mes_router~change_idoc.


    RETURN.

    TYPES : BEGIN OF ty_idoc_data_index,
              index     TYPE i,
              idoc_data TYPE edidd,
            END OF ty_idoc_data_index.
    DATA lt_idoc_data_index TYPE TABLE OF ty_idoc_data_index.
    DATA : lt_idoc_data_constant_lines    TYPE edidd_tt,
           lv_idoc_data_constant_lines_ok TYPE xfeld.
    DATA lv_index TYPE i.
    DATA ls_e1plfll TYPE e1plfll.

    CLEAR : lt_idoc_data_index[], lt_idoc_data_constant_lines[], lv_idoc_data_constant_lines_ok, lv_index.





    CONSTANTS:  lc_e1plfll  TYPE edidd-segnam VALUE 'E1PLFLL'.
    DATA : lt_syntax         TYPE STANDARD TABLE OF edi_iapi02,
           lr_segtyp_exclude TYPE RANGE OF edilsegtyp.


    CALL FUNCTION 'IDOCTYPE_READ'
      EXPORTING
        pi_idoctyp         = cs_idoc_header-idoctp
        pi_check_authority = ' '
        pi_read_devc       = ' '
      TABLES
        pt_syntax          = lt_syntax
      EXCEPTIONS
        object_not_found   = 1
        db_error           = 2
        no_authority       = 3.

    READ TABLE lt_syntax INTO DATA(ls_syntax) WITH KEY parseg = lc_e1plfll.

    APPEND VALUE #( sign = 'E' option = 'EQ' low = ls_syntax-parseg ) TO lr_segtyp_exclude.

    LOOP AT lt_syntax INTO DATA(ls_data) WHERE parpno >= ls_syntax-parpno.
      APPEND VALUE #( sign = 'E' option = 'EQ' low = ls_data-segtyp ) TO lr_segtyp_exclude.
    ENDLOOP.





    LOOP AT ct_idoc_data ASSIGNING FIELD-SYMBOL(<fs_idoc_data>).

      "E1PLFLL segnemntine kadar olan satırları her idocda göndermek için kullanacağız.
      "bu yüzden tek seferlik bu satırları itab a al.
      IF ( <fs_idoc_data>-segnam IN lr_segtyp_exclude ).
        APPEND <fs_idoc_data> TO lt_idoc_data_constant_lines.
        CONTINUE.
      ENDIF.

      IF <fs_idoc_data>-segnam = lc_e1plfll.
        lv_index = lv_index + 1.
      ENDIF.

      APPEND VALUE ty_idoc_data_index( index = lv_index
                                       idoc_data = <fs_idoc_data> ) TO lt_idoc_data_index.


      IF lv_index > 1.
        DELETE ct_idoc_data.
      ENDIF.

    ENDLOOP.

    DELETE lt_idoc_data_index WHERE index <= 1.

*    BREAK : 52683, 18885.


    DATA lt_send_idoc_data TYPE edidd_tt.
    LOOP AT lt_idoc_data_index INTO DATA(ls_idoc_data_index) GROUP BY ( index = ls_idoc_data_index-index ).

      CLEAR lt_send_idoc_data[].


      APPEND LINES OF lt_idoc_data_constant_lines TO lt_send_idoc_data.
      DATA ls_e1mapal TYPE e1mapal.
**      LOOP AT lt_send_idoc_data ASSIGNING FIELD-SYMBOL(<fs_send_idoc_data>) WHERE segnam = 'E1MAPAL'.
**
**        ls_e1mapal = <fs_send_idoc_data>-sdata.
**        ls_e1mapal-plnal = ls_idoc_data_index-index.
**        <fs_send_idoc_data>-sdata = ls_e1mapal.
**      ENDLOOP.

      LOOP AT GROUP ls_idoc_data_index ASSIGNING FIELD-SYMBOL(<fs_idoc_data_index_group>).
*
        IF <fs_idoc_data_index_group>-idoc_data-segnam = lc_e1plfll.
          ls_e1plfll =  <fs_idoc_data_index_group>-idoc_data-sdata.
          ls_e1plfll-flgat = 0.
          <fs_idoc_data_index_group>-idoc_data-sdata = ls_e1plfll.
        ENDIF.

        APPEND <fs_idoc_data_index_group>-idoc_data TO lt_send_idoc_data.
      ENDLOOP.



      "send..
      DATA lt_idoc_comm_control TYPE TABLE OF edidc.
      CLEAR : lt_idoc_comm_control.
      CALL FUNCTION 'MASTER_IDOC_DISTRIBUTE'
        EXPORTING
          master_idoc_control            = cs_idoc_header
        TABLES
          communication_idoc_control     = lt_idoc_comm_control
          master_idoc_data               = lt_send_idoc_data
        EXCEPTIONS
          error_in_idoc_control          = 1
          error_writing_idoc_status      = 2
          error_in_idoc_data             = 3
          sending_logical_system_unknown = 4
          OTHERS                         = 5.


    ENDLOOP.




  ENDMETHOD.
ENDCLASS.
