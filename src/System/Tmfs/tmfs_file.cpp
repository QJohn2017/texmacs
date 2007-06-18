
/******************************************************************************
* MODULE     : tmfs_file.cpp
* DESCRIPTION: files and projects
* COPYRIGHT  : (C) 2007  Joris van der Hoeven
*******************************************************************************
* This software falls under the GNU general public license and comes WITHOUT
* ANY WARRANTY WHATSOEVER. See the file $TEXMACS_PATH/LICENSE for more details.
* If you don't have this file, write to the Free Software Foundation, Inc.,
* 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
******************************************************************************/

#include "tmfs.hpp"

/******************************************************************************
* Versioning routines
******************************************************************************/

string
tmfs_create_file (string name, string contents, string user) {
  string master= tmfs_create_identifier ();
  string file  = tmfs_create_ressource ();
  properties ps;
  ps << seq ("file", file)
     << seq ("name", file, name)
     << seq ("master", file, master)
     << seq ("owner", file, user)
     << seq ("in", file, user)
     << seq ("read", file, user)
     << seq ("write", file, user);
  tmfs_save_ressource (file, contents, ps);
  return file;
}

collection
tmfs_search_file (string name) {
  properties ps; ps << seq ("name", "?file", name) << seq ("file", "?file");
  return tmfs_query (ps, "?file");
}

void
tmfs_save (string file, string contents, properties ps) {
  if (tmfs_allows (file, "write") && tmfs_allows (file, "owner"))
    tmfs_save_ressource (file, contents, ps);
}

void
tmfs_save_file (string file, string cont) {
  if (tmfs_allows (file, "write"))
    tmfs_save_ressource (file, cont, tmfs_load_ressource_properties (file));
}

string
tmfs_load_file (string file) {
  if (tmfs_allows (file, "read"))
    return tmfs_load_ressource_file (file);
  return "";
}

void
tmfs_set_file_properties (string file, properties ps) {
  if (tmfs_allows (file, "owner"))
    tmfs_save_ressource (file, tmfs_load_ressource_file (file), ps);
}

properties
tmfs_get_file_properties (string file) {
  if (tmfs_allows (file, "read"))
    return tmfs_load_ressource_properties (file);
  return properties ();
}

void
tmfs_add_file_properties (string file, properties add_ps) {
  properties ps= tmfs_get_file_properties (file);
  ps= reset (ps, add_ps);
  ps << add_ps;
  tmfs_set_file_properties (file, ps);
}

void
tmfs_remove_file_properties (string file, properties sub_ps) {
  properties ps= tmfs_get_file_properties (file);
  ps= reset (ps, sub_ps);
  tmfs_set_file_properties (file, ps);
}

/******************************************************************************
* Projects
******************************************************************************/

string
tmfs_create_project (string name, string user) {
  string project= tmfs_create_ressource ();
  string home= tmfs_create_file (name * " - home", "", project);
  properties ps;
  ps << seq ("project", project)
     << seq ("name", project, name)
     << seq ("owner", project, user)
     << seq ("in", project, user)
     << seq ("read", project, user)
     << seq ("write", project, user)
     << seq ("home", project, home);
  tmfs_save_ressource (project, "", ps);
  return project;
}

collection
tmfs_search_project (string name) {
  properties ps; ps << seq ("name", "?p", name) << seq ("project", "?p");
  return tmfs_query (ps, "?p");
}

collection
tmfs_get_file_projects (string file) {
  return tmfs_query (seq ("in", file, "?project"), "?project");
}

collection
tmfs_get_project_files (string project) {
  collection files= tmfs_query (seq ("in", "?file", project), "?file");
  collection homes= tmfs_query (seq ("home", project, "?home"), "?home");
  return files * invert (homes);
}

/******************************************************************************
* Branches
******************************************************************************/

void
tmfs_branch_file (string old_file, string branch) {
  string contents= tmfs_load_file (old_file);
  properties ps  = tmfs_get_file_properties (old_file);
  string new_file= tmfs_create_ressource ();
  ps= substitute (ps, old_file, new_file);
  properties mp;
  mp << seq ("owner", old_file, "?user")
     << seq ("in", old_file, "?user")
     << seq ("read", old_file, "?user")
     << seq ("write", old_file, "?user");
  ps= reset (ps, mp);
  ps << seq ("owner", new_file, branch)
     << seq ("in", new_file, branch)
     << seq ("read", new_file, branch)
     << seq ("write", new_file, branch);
  tmfs_save_ressource (new_file, contents, ps);
}

string
tmfs_create_branch (string project, string name, string user) {
  collection c= tmfs_query (seq ("name", project, "?name"), "?name");
  if (N(c) == 0) return "";
  string full_name= first (c) * " - " * name;
  string branch= tmfs_create_project (full_name, user);
  strings files= as_strings (tmfs_get_project_files (project));
  for (int i=0; i<N(files); i++)
    tmfs_branch_file (files[i], branch);
  return branch;
}
