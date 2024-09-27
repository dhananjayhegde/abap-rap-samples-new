# Overview
This is a live repo for all my explorations with RAP, OData v4, Fiori Elements and Hierarchies etc.  
They are sometimes featured on my blog too (which is currently in migration)

- Original Blog: [Dhananjay Hegde's Presonal Blog](https://dhananjayhegde.in)
- New one under development: [Dhananjay Hegde's Presonal Blog migrated - temporary site](https://dhananjayhegde.netlify.app)

Some topics you might like:
- [Series on ABAP RAP, CAP etc.](https://dhananjayhegde.netlify.app/series/)
- [Series on ABAP RAP, CAP etc. on original site](https://dhananjayhegde.in/series/)

# ABAP RAP Samples - compatiable with abapGit
Earlier [ABAP Sample Repo](https://github.com/dhananjayhegde/ABAP-RAP-Samples) was not compatible with abapGit - i.e. code was manually copied to the repo instead of pushing them via abapGit. So, if someone wanted to reuse them, it would be very difficult to manually navigate through different files and figure out what to take over.

So, I decided to create a new package and use that for all future `Sample` development.  Now, I use abapGit to push the code from my Trial account to this repo.  This will also help me in future when my own Trial account gets deleted and I have to create new one!

# Packages

There are more packages and exampels on OData v4 with hierarchies etc. in this repo.  Clone it and try them out:

| Package        | Usage                                                                                                                                                        |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ZDH_RAP_AUNITS | As the name would suggest, started as a project to demonstrate ABAP Units for RAP Business Objects.  But, later becamse `RAP Managed BO with Late Numbering` |
| ZDH_V4_HIER_RO | (OData V4) Read-only CDS Hierarchy based Fiori Elements appliction with hierarchy being shown on the List Report page instead of object page                 |
| ZDH_V4_HIER_ACT | (OData V4 + RAP) CDS Hierarchy based Fiori Elements appliction with hierarchy being shown on the List Report page + actions                                 |

