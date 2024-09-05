# Using classes in building a templated Data Pipeline that can be driven by Metadata

Let's imagine we have some ficticious API to call data from... There are a number of API calls we wish to make.<br>
They may come from the same base source, for example, but each has its own data structure of columns / nested columns to contest with.<br>

We can design an approach that uses a template python process, driven by metadata, to process each API call in a loop.<br>
This code base in an example approach.<br>

