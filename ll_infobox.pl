:- module(ll_infobox, []).

/** <module> LOD Laundromat Infobox

Serves responses for the contents of a metadata infobox in HTML,
for use in LOD Laundromat.

@author Wouter Beek
@version 2014/07-2014/08, 2015/01
*/

:- use_module(library(aggregate)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_header)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_session)). % HTTP session support.
:- use_module(library(semweb/rdf_db), except([rdf_node/1])).

:- use_module(plUri(uri_query)).

:- use_module(plHttp(request_ext)).

:- use_module(plRdf(term/rdf_string)).

:- use_module(plTabular(rdf_html_table)).

:- use_module(lle(lle_settings)).

:- http_handler(lle(infobox), ll_infobox, [id(ll_infobox)]).





ll_infobox(Request):-
  cors_enable,
  ll_infobox_with_cors(Request).

ll_infobox_with_cors(Request):-
  request_query_nvpair(Request, md5, Md5), !,
  lle_version_graph(Graph),
  aggregate_all(
    set([P,O]),
    (
      rdf_string(Datadoc, llo:md5, Md5, Graph),
      rdf(Datadoc, P, O, Graph)
    ),
    Rows
  ),
  phrase(
    html(
      \rdf_html_table(
        _NoCaption,
        Rows,
        [graph(Graph),header_row(po)]
      )
    ),
    Tokens
  ),
  print_html(Tokens).
ll_infobox_with_cors(_):-
  throw(http_reply(bad_request('Could not find md5 search term.'))).

