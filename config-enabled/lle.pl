:- module(conf_lle, []).



% Web root.
:- dynamic(http:location/3).
:- multifile(http:location/3).
http:location(lle, cliopatria(lle), []).



% Current HTML style set to ClioPatria default.
user:current_html_style(cliopatria(default)).



/*
% HTML resources.
:- html_resource(
     css(plTabular),
     [requires([css('plTabular.css')]),virtual(true)]
   ).
*/



% ClioPatria menu items.
:- multifile(cliopatria:menu_item/2).
cliopatria:menu_item(500=lle/ll_web_errors, 'LOD Errors').
cliopatria:menu_item(500=lle/ll_web_progress, 'LOD Progress').
cliopatria:menu_item(600=lle/plTabular, plTabular).



% Load modules.
:- if(\+ current_module(load_project)).
  :- if(current_prolog_flag(argv, ['--debug'])).
    :- ensure_loaded('../debug').
  :- else.
    :- ensure_loaded('../load').
  :- endif.
:- endif.

