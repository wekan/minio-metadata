#!/bin/bash

source settings.sh

rm wekan.sqlite csv/*.csv

mongoexport --uri="${MONGOURI}" --collection=accountSettings --type=csv --fieldFile=fields/accountSettings-fields.txt --out=csv/accountSettings.csv
mongoexport --uri="${MONGOURI}" --collection=actions --type=csv --fieldFile=fields/actions-fields.txt --out=csv/actions.csv
mongoexport --uri="${MONGOURI}" --collection=activities --type=csv --fieldFile=fields/activities-fields.txt --out=csv/activities.csv
mongoexport --uri="${MONGOURI}" --collection=announcements --type=csv --fieldFile=fields/announcements-fields.txt --out=csv/announcements.csv
mongoexport --uri="${MONGOURI}" --collection=attachments --type=csv --fieldFile=fields/attachments-fields.txt --out=csv/attachments.csv
mongoexport --uri="${MONGOURI}" --collection=attachments.files --type=csv --fieldFile=fields/attachments.files-fields.txt --out=csv/attachments.files.csv
mongoexport --uri="${MONGOURI}" --collection=avatars --type=csv --fieldFile=fields/avatars-fields.txt --out=csv/avatars.csv
mongoexport --uri="${MONGOURI}" --collection=avatars.files --type=csv --fieldFile=fields/avatars.files-fields.txt --out=csv/avatars.files.csv
mongoexport --uri="${MONGOURI}" --collection=cfs.attachments.filerecord --type=csv --fieldFile=fields/cfs.attachments.filerecord-fields.txt --out=csv/cfs.attachments.filerecord.csv
mongoexport --uri="${MONGOURI}" --collection=cfs.avatars.filerecord --type=csv --fieldFile=fields/cfs.avatars.filerecord-fields.txt --out=csv/cfs.avatars.filerecord.csv
mongoexport --uri="${MONGOURI}" --collection=cfs_gridfs.attachments.files --type=csv --fieldFile=fields/cfs_gridfs.attachments.files-fields.txt --out=csv/cfs_gridfs.attachments.files.csv
mongoexport --uri="${MONGOURI}" --collection=cfs_gridfs.avatars.files --type=csv --fieldFile=fields/cfs_gridfs.avatars.files-fields.txt --out=csv/cfs_gridfs.avatars.files.csv
mongoexport --uri="${MONGOURI}" --collection=boards --type=csv --fieldFile=fields/boards-fields.txt --out=csv/boards.csv
mongoexport --uri="${MONGOURI}" --collection=cards --type=csv --fieldFile=fields/cards-fields.txt --out=csv/cards.csv
mongoexport --uri="${MONGOURI}" --collection=card_comment_reactions --type=csv --fieldFile=fields/card_comment_reactions-fields.txt --out=csv/card_comment_reactions.csv
mongoexport --uri="${MONGOURI}" --collection=card_comments --type=csv --fieldFile=fields/card_comments-fields.txt --out=csv/card_comments.csv
mongoexport --uri="${MONGOURI}" --collection=checklists --type=csv --fieldFile=fields/checklists-fields.txt --out=csv/checklists.csv
mongoexport --uri="${MONGOURI}" --collection=checklistItems --type=csv --fieldFile=fields/checklistItems-fields.txt --out=csv/checklistItems.csv
mongoexport --uri="${MONGOURI}" --collection=customFields --type=csv --fieldFile=fields/customFields-fields.txt --out=csv/customFields.csv
mongoexport --uri="${MONGOURI}" --collection=impersonatedUsers --type=csv --fieldFile=fields/impersonatedUsers-fields.txt --out=csv/impersonatedUsers.csv
mongoexport --uri="${MONGOURI}" --collection=integrations --type=csv --fieldFile=fields/integrations-fields.txt --out=csv/integrations.csv
mongoexport --uri="${MONGOURI}" --collection=lists --type=csv --fieldFile=fields/lists-fields.txt --out=csv/lists.csv
mongoexport --uri="${MONGOURI}" --collection=org --type=csv --fieldFile=fields/org-fields.txt --out=csv/org.csv
mongoexport --uri="${MONGOURI}" --collection=orgUser --type=csv --fieldFile=fields/orgUser-fields.txt --out=csv/orgUser.csv
mongoexport --uri="${MONGOURI}" --collection=rules --type=csv --fieldFile=fields/rules-fields.txt --out=csv/rules.csv
mongoexport --uri="${MONGOURI}" --collection=settings --type=csv --fieldFile=fields/settings-fields.txt --out=csv/settings.csv
mongoexport --uri="${MONGOURI}" --collection=swimlanes --type=csv --fieldFile=fields/swimlanes-fields.txt --out=csv/swimlanes.csv
mongoexport --uri="${MONGOURI}" --collection=tableVisibilityModeSettings --type=csv --fieldFile=fields/tableVisibilityModeSettings-fields.txt --out=csv/tableVisibilityModeSettings.csv
mongoexport --uri="${MONGOURI}" --collection=team --type=csv --fieldFile=fields/team-fields.txt --out=csv/team.csv
mongoexport --uri="${MONGOURI}" --collection=triggers --type=csv --fieldFile=fields/triggers-fields.txt --out=csv/triggers.csv
mongoexport --uri="${MONGOURI}" --collection=unsaved-edits --type=csv --fieldFile=fields/unsaved-edits-fields.txt --out=csv/unsaved-edits.csv
mongoexport --uri="${MONGOURI}" --collection=sessiondata --type=csv --fieldFile=fields/sessiondata-fields.txt --out=csv/sessiondata.csv
mongoexport --uri="${MONGOURI}" --collection=users --type=csv --fieldFile=fields/users-fields.txt --out=csv/users.csv
mongoexport --uri="${MONGOURI}" --collection=esCounts --type=csv --fieldFile=fields/esCounts-fields.txt --out=csv/esCounts.csv
mongoexport --uri="${MONGOURI}" --collection=meteor_accounts_loginServiceConfiguration --type=csv --fieldFile=fields/meteor_accounts_loginServiceConfiguration-fields.txt --out=csv/meteor_accounts_loginServiceConfiguration.csv
mongoexport --uri="${MONGOURI}" --collection=meteor-migrations --type=csv --fieldFile=fields/meteor-migrations-fields.txt --out=csv/meteor-migrations.csv
mongoexport --uri="${MONGOURI}" --collection=presences --type=csv --fieldFile=fields/presences-fields.txt --out=csv/presences.csv

echo ".mode csv
.import csv/accountSettings.csv accountSettings
.import csv/actions.csv actions
.import csv/activities.csv activities
.import csv/announcements.csv announcements
.import csv/attachments.csv attachments
.import csv/attachments.files.csv attachments.files
.import csv/avatars.csv avatars
.import csv/avatars.files.csv avatars.files
.import csv/cfs.attachments.filerecord.csv cfs.attachments.filerecord
.import csv/cfs.avatars.filerecord.csv cfs.avatars.filerecord
.import csv/cfs_gridfs.attachments.files.csv cfs_gridfs.attachments.files
.import csv/cfs_gridfs.avatars.files.csv cfs_gridfs.avatars.files
.import csv/boards.csv boards
.import csv/cards.csv cards
.import csv/card_comments.csv card_comments
.import csv/card_comment_reactions.csv card_comment_reactions
.import csv/checklists.csv checklists
.import csv/checklistItems.csv checklistItems
.import csv/customFields.csv customFields
.import csv/impersonatedUsers.csv impersonatedUsers
.import csv/integrations.csv integrations
.import csv/lists.csv lists
.import csv/org.csv org
.import csv/orgUser.csv orgUser
.import csv/rules.csv rules
.import csv/settings.csv settings
.import csv/swimlanes.csv swimlanes
.import csv/tableVisibilityModeSettings.csv tableVisibilityModeSettings
.import csv/team.csv team
.import csv/triggers.csv triggers
.import csv/unsaved-edits.csv unsaved-edits
.import csv/sessiondata.csv sessiondata
.import csv/users.csv users
.import csv/esCounts.csv esCounts
.import csv/meteor_accounts_loginServiceConfiguration.csv meteor_accounts_loginServiceConfiguration
.import csv/meteor-migrations.csv meteor-migrations
.import csv/presences.csv presences
.quit" | sqlite3 wekan.sqlite
