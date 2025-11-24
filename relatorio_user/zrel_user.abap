REPORT ZREL_USER.

TABLES: usr02, usr21.

TYPES: BEGIN OF ty_users,
         bname     TYPE usr02-bname, "Código do usuário
         name_text TYPE adrp-name_text, " Nome do usuário
         gltgv     TYPE usr02-gltgv, " Válido desde
         gltgb     TYPE usr02-gltgb, " Válido até
         uflag     TYPE usr02-uflag, " Bloqueio
         aname     TYPE usr02-aname, " Criado por
         erdat     TYPE usr02-erdat, " Data de criação
         trdat     TYPE usr02-trdat, " Última data de logon
         color     TYPE lvc_t_scol,  " Color
       END OF ty_users.

CLASS lcl_events DEFINITION.
  PUBLIC SECTION.
    METHODS click_link FOR EVENT link_click OF cl_salv_events_table
      IMPORTING column row sender.
ENDCLASS.


DATA: it_users TYPE TABLE OF ty_users,
      wa_users TYPE ty_users,
      lo_alv   TYPE REF TO cl_salv_table.

CLASS lcl_events IMPLEMENTATION.
  METHOD click_link.
    CASE column.
      WHEN 'BNAME'.
        READ TABLE it_users INTO wa_users INDEX row.

        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

        SET PARAMETER ID 'XUS' FIELD wa_users-bname.
        CALL TRANSACTION 'SU01D' AND SKIP FIRST SCREEN.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  SELECT-OPTIONS s_bname FOR usr02-bname.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM: query.
  PERFORM: before_output.
  PERFORM: output.
*&---------------------------------------------------------------------*
*& Form query
*&---------------------------------------------------------------------*
FORM query .

  SELECT a~bname c~name_text a~gltgv a~gltgb a~uflag a~aname a~erdat a~trdat
    FROM usr02 AS a
    INNER JOIN usr21 AS b
    ON a~bname EQ b~bname
    LEFT JOIN adrp AS c
    ON b~persnumber EQ c~persnumber
    INTO CORRESPONDING FIELDS OF TABLE it_users
    WHERE a~bname IN s_bname.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form before_output
*&---------------------------------------------------------------------*
FORM before_output .
  DATA ls_color LIKE LINE OF wa_users-color.
  DATA ls_cont TYPE sy-tabix.

  LOOP AT it_users INTO wa_users.
    IF wa_users-uflag IS NOT INITIAL.
      ls_color-color-col = 6.
      ls_color-fname = 'UFLAG'.
      ls_cont = sy-tabix.
      APPEND ls_color TO wa_users-color.
      MODIFY it_users FROM wa_users INDEX ls_cont.
    ENDIF.

    IF sy-datum => wa_users-gltgv AND wa_users-gltgb <= sy-datum.
      ls_color-color-col = 6.
      ls_color-fname = 'GLTGB'.
      ls_cont = sy-tabix.
      APPEND ls_color TO wa_users-color.

      ls_color-fname = 'GLTGV'.
      APPEND ls_color TO wa_users-color.
      MODIFY it_users FROM wa_users INDEX ls_cont.

    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form output
*&---------------------------------------------------------------------*
FORM output .
  DATA: lo_event            TYPE REF TO cl_salv_events_table,
        lo_event_click_link TYPE REF TO lcl_events,
        lo_column           TYPE REF TO cl_salv_column_table.

  lo_event_click_link = NEW lcl_events( ).

  TRY.
      cl_salv_table=>factory(

        IMPORTING
          r_salv_table   = lo_alv
        CHANGING
          t_table        = it_users
      ).
      lo_event = lo_alv->get_event( ).
      SET HANDLER lo_event_click_link->click_link FOR lo_event.


      lo_alv->get_columns( )->set_optimize( abap_true ).
      lo_alv->get_functions( )->set_all( abap_true ).
      lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).

      lo_alv->get_columns( )->set_color_column( 'COLOR' ).
      lo_column ?= lo_alv->get_columns( )->get_column( 'BNAME' ).
      lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).

      lo_alv->display( ).
    CATCH cx_salv_msg.
  ENDTRY.
ENDFORM.
