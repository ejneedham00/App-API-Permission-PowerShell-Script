<h1>Find Apps With a Specific API Permission</h1>

<h2>What it does</h2>

<p>This script is for finding which apps in your tenant have been given a certain application permissions. You give it an API and a permission name, and it lists every app registration that has that permission assigned, then dumps the list to a CSV.</p>

<h2>How it works</h2>

<ol>
  <li>Signs into Microsoft Graph with <code>Connect-MgGraph</code>. It only asks for <code>Application.Read.All</code> and <code>Directory.Read.All</code>, so it's read-only and won't change anything in your tenant.</li>
  <li>Uses two variables you set at the top:
    <ul>
      <li><code>$ApiAppId</code> is the App ID of the API you want to check. For Microsoft Graph that's <code>00000003-0000-0000-c000-000000000000</code>.</li>
      <li><code>$PermissionName</code> is the permission you're hunting for, like <code>User.ReadWrite.All</code>.</li>
    </ul>
  </li>
  <li>Looks up that API in your tenant. If it can't find it, it throws an error and stops.</li>
  <li>Checks the API's app roles for the permission name. If the permission doesn't exist on that API, it throws an error and stops.</li>
  <li>Pulls every app role assignment on the API and keeps only the ones for your permission.</li>
  <li>Looks up each app that has the permission and grabs its:
    <ul>
      <li><code>ApplicationName</code> (display name)</li>
      <li><code>AppId</code></li>
      <li><code>ObjectId</code></li>
      <li><code>Permission</code> (just the name you searched for)</li>
    </ul>
  </li>
  <li>Prints the results as a table, sorted by app name, and saves them to <code>AppsAPIPermission.csv</code> in whatever folder you ran the script from.</li>
</ol>

<h2>Prerequisites</h2>

<ul>
  <li>The Microsoft Graph PowerShell SDK (<code>Microsoft.Graph.Applications</code> module)</li>
  <li>An account that can use <code>Application.Read.All</code> and <code>Directory.Read.All</code></li>
</ul>

<h2>Notes / Limitations</h2>

<ul>
  <li>This only covers <b>application permissions</b> (app-only access). It won't show delegated permissions.</li>
  <li>The permission name has to match the full value exactly. Case doesn't matter, but <code>user.readwrite</code> won't match <code>User.ReadWrite.All</code>, so use the full name.</li>
  <li>It assumes everything with the permission assigned is a service principal, which is almost always the case.</li>
</ul>
