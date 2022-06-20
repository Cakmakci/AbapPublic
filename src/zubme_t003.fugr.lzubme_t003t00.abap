*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 03.03.2022 at 17:51:28
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_T003......................................*
DATA:  BEGIN OF STATUS_ZUBME_T003                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBME_T003                    .
CONTROLS: TCTRL_ZUBME_T003
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBME_T003                    .
TABLES: ZUBME_T003                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
