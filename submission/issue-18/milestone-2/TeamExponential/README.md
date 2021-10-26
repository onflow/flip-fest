- summary
- screenshot walktrhough

# Playground Feature: Markdown READMEs #18 - Milestone 2
Thank you for reading our Milestone 2 submission, "Implement UI changes.". After receiving [feedback from Max and Pete](https://github.com/onflow/flip-fest/pull/40#issuecomment-926683566), we iterated on our design, moving the project title, description and readme functionality from a button in the top right of the playground that rendered a popup, to a button in the sidebar that utilizes the playground editor window to display the functionality. The first version of our UI design can be found in the [mockups for Milestone 1 submission](https://github.com/hichana/flip-fest/tree/submissions/issue-%2318/milestone-%231/TeamExponential/submissions/issue-%2318/milestone-%231/TeamExponential/wireframe-mockups). Please note that with this milestone 2 we are not making a code submission as that will be made with Milestone 3 "Add support for storing and loading the README data on the frontend.". Below is a screenshot walkthrough of the new/iterated UI with typical user flows.


### First load of the playground:
- the user is encouraged to immediately start playing with contracts, scripts or transactions just as they are with the current playground. 
![first load](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/1%20-%20first%20load.png?raw=true)


### User clicks 'Save' button:
- now that the user is serious about making something either for their own use or to share, we redirect them to the 'PROJECT' editor upon clicking 'Save'. 
- The URL now includes the project id and type as 'readme'
![save url](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/2%20-%201%20-%20save,%20url.png?raw=true)

- user enters title, description and readme content. Title populates the browser tab with text every three seconds after user enters text.
![title, text tab](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/2%20-%202%20-%20title,%20tab%20text.png?raw=true)

- user can click on any other account, tx or script and the url updates as normal. Upon clicking back on the 'PROJECT' button the URL updates accordingly and the user is shown persisted content that was autosaved.
![same click routing as before](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/2%20-%203%20-%20same%20click%20routing%20as%20before.png?raw=true)

![back to readme url](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/2%20-%204%20-%20back%20to%20readme%20url.png?raw=true)

- user can see a preview of the markdown by clicking on the 'eye' icon in the markdown editor toolbar
![eye preview](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/2%20-%205%20-%20eye%20preview.png?raw=true)

- optionally, the user can see a full-screen split version of the markdown by clicking on the 'split' icon in the markdown editor toolbar
![optional split screen](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/2%20-%206%20-%20split%20screen%20option.png?raw=true)

### User clicks 'Share' button:
- as before, the share link will be a direct link to the section of current selection, giving the user freedom to share whichever part of the playground they choose
![share](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/3%20-%201%20-%20share.png?raw=true)


### User clicks 'Export' button:
- same functionality from before exists
![export popup](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/4%20-%201%20-%20export%20popup.png?raw=true)

- the download file now bears the project name  
![title1](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/4%20-%202%20-%20title.png?raw=true)
![title2](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/4%20-%202%20-%20title2.png?raw=true)

- the README.md file is included in the download package and can be opened up in a code editor like VS Code 
![readme file](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/4%20-%203%20-%201%20readme%20file.png?raw=true)

  - in the readme file, note that the 'Title' is added as an H1 heading, 'Description' as an H2 heading with its text, and Readme content are all present
  ![open readme in code editor](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/4%20-%203%20-%202%20open%20readme%20in%20code%20editor.png?raw=true)

Visitor to the playground:
- sees the title, description and readme content as HTML  
![visitor html](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/5%20-%201%20-%20visitor%20html.png?raw=true)

Visitor to the playgorund clicks the 'Fork' button:
- first, if the visitor explores the project before clicking the 'Fork' button, they will see the owner's original code as usual
- upon clicking the 'Fork' button, they are redirected to the PROJECT section, encouraging them to establish the title, description and readme content for their forked version
![visitor redirected](https://github.com/hichana/flip-fest/blob/submissions/issue-%2318/milestone-%232/TeamExponential/submission/issue-18/milestone-2/TeamExponential/readme-images/6%20-%201%20-%20visitor%20redirected.png?raw=true)



