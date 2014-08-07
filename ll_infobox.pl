:- module(
  ll_infobox,
  [
    ll_infobox/1 % +Request:list(nvpair)
  ]
).

/** <module> LOD Laundromat Infobox

Serves responses for the contents of a metadata infobox in HTML,
for use in LOD Laundromat.

@author Wouter Beek
@version 2014/07-2014/08
*/

:- use_module(library(aggregate)).
:- use_module(library(http/http_header)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_session)). % HTTP session support.
:- use_module(library(semweb/rdf_db)).

:- use_module(generics(uri_search)).

:- use_module(plRdf_term(rdf_string)).

:- use_module(plTabular(rdf_html_table)).



ll_infobox(Request):-
  cors_enable,
  ll_infobox_with_cors(Request).

ll_infobox_with_cors(Request):-
  request_search_read(Request, md5, Md5), !,
  ll_sparql_default_graph(dissemination, Graph),
  aggregate_all(
    set([P,O]),
    (
      rdf_string(Datadoc, ll:md5, Md5, Graph),
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



% Helpers

%! ll_sparql_default_graph(
%!   +Mode:oneof([collection,dissemination]),
%!   -DefaultGraph:iri
%! ) is det.

ll_sparql_default_graph(Mode, DefaultGraph):-
  ll_dissemination_version(Version),
  atom_number(Fragment, Version),
  uri_components(
    DefaultGraph,
    uri_components(http, 'lodlaundromat.org', _, _, Fragment)
  ).

ll_dissemination_version(10).

