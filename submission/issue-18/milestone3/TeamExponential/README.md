# Playground Feature: Markdown READMEs - Milestone 3

## Description

This PR is for issue #18.

This PR adds support for storing and loading the README data in the frontend. 
The code follows the existing design patterns used in the frontend codebase. Namely the existing router. 

We tried several markdown editors and settled on [react-simplemde-editor](https://www.npmjs.com/package/react-simplemde-editor) a react wrapper for the popular and well maintained [easy-markdown-editor](https://github.com/Ionaru/easy-markdown-editor). 

We chose this editor as it renders the syntax while editing to clearly show the expected result (rather than requiring a separate preview section). Headings are larger, emphasized words are italicized, links are underlined, etc. It also allows users who may be less experienced with Markdown to use familiar toolbar buttons and shortcuts.

We also added the [unreset-css](https://www.npmjs.com/package/unreset-css) package to provide default browser styling to the markup (removed elsewhere in the project with reset.css)  

Our code contribution to the flow-playground can be found here: [#173](https://github.com/onflow/flow-playground/pull/173)
