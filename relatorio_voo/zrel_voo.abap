REPORT ZREL_VOO.

TABLES: sflight.

TYPES: BEGIN OF ty_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
       END OF ty_scarr.

TYPES: BEGIN OF ty_spfli,
         carrid   TYPE spfli-carrid,
         connid   TYPE spfli-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
       END OF ty_spfli.

TYPES: BEGIN OF ty_sflight,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
         fldate TYPE sflight-fldate,
         price  TYPE sflight-price,
       END OF ty_sflight.

TYPES: BEGIN OF ty_voo,
         carrid   TYPE scarr-carrid,
         connid   TYPE spfli-connid,
         carrname TYPE scarr-carrname,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
         fldate   TYPE sflight-fldate,
         price    TYPE sflight-price,
       END OF ty_voo.

DATA: wa_scarr         TYPE ty_scarr,
      it_scarr         TYPE TABLE OF ty_scarr,
      wa_spfli         TYPE ty_spfli,
      it_spfli         TYPE TABLE OF ty_spfli,
      wa_sflight       TYPE ty_sflight,
      it_sflight       TYPE TABLE OF ty_sflight,
      wa_voo           TYPE ty_voo,
      it_voo           TYPE TABLE OF ty_voo,
      lo_alv           TYPE REF TO cl_salv_table.

Selection-screen BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS: s_carrid FOR sflight-carrid,
                s_connid FOR sflight-connid.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

PERFORM: f_select_for_data_input.
PERFORM: f_process_input.
PERFORM: f_output.

*&---------------------------------------------------------------------*
*& Form f_select_for_data_input
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_select_for_data_input .
*  SELECT carrid carrname
*    FROM scarr
*    INTO TABLE it_scarr
*    WHERE carrid IN s_carrid.
*
*  SELECT carrid connid cityfrom cityto
*    FROM spfli
*    INTO TABLE it_spfli
*    WHERE carrid IN s_carrid AND connid IN s_connid.
*
*  SELECT carrid connid fldate price
*    FROM sflight
*    INTO TABLE it_sflight
*    WHERE carrid IN s_carrid AND connid IN s_connid.

  SELECT a~carrid b~connid a~carrname b~cityfrom b~cityto c~fldate c~price
    FROM scarr AS a
    INNER JOIN spfli AS b
    ON a~carrid EQ b~carrid
    INNER JOIN sflight AS c
    ON a~carrid EQ c~carrid AND b~connid EQ c~connid
    INTO TABLE it_voo
    WHERE a~carrid IN s_carrid AND b~connid IN s_connid.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_process_input
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_process_input .

*  IF it_scarr IS INITIAL AND ( it_spfli IS INITIAL AND it_sflight IS INITIAL ).
*    MESSAGE 'Dados sobre o Voo não encontrados!' TYPE 'I'.
*   ELSE.
*
*  LOOP AT it_spfli INTO wa_spfli.
*    CLEAR: wa_voo.
*    MOVE-CORRESPONDING wa_spfli to wa_voo.
*
*    LOOP AT it_scarr INTO wa_scarr WHERE carrid EQ wa_spfli-carrid.
*      MOVE-CORRESPONDING wa_scarr to wa_voo.
*    ENDLOOP.
*
*    LOOP AT it_sflight INTO wa_sflight WHERE carrid EQ wa_spfli-carrid AND connid EQ wa_spfli-connid.
*      MOVE-CORRESPONDING wa_sflight TO wa_voo.
*    ENDLOOP.
*
*    APPEND: wa_voo TO it_voo.
*  ENDLOOP.
*
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_output
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_output .
  TRY.
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = lo_alv
    CHANGING
      t_table        = it_voo
  ).
  lo_alv->get_functions( )->set_all( abap_true ).
  lo_alv->get_columns( )->set_optimize( abap_true ).
  lo_alv->get_display_settings( )->set_striped_pattern( abap_true ).
  lo_alv->display( ).
  CATCH cx_salv_msg.
    ENDTRY.


ENDFORM.
