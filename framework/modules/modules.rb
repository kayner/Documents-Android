# frozen_string_literal: true

require_relative 'common/bottom_navigation_bar'
require_relative 'common/common_file_list'
require_relative 'common/context_menu'
require_relative 'common/dialog'
require_relative 'common/plus_fab'
require_relative 'common/top_tool_bar'
require_relative 'common/storages/google'
require_relative 'common/storages/dropbox'
require_relative 'common/storages/yandexdisk'
require_relative 'common/storages/box'
require_relative 'common/storages/owncloud'
require_relative 'common/storages/nextcloud'
require_relative 'common/storages/webdav'
require_relative 'common/storages/sharepoint'
require_relative 'common/storages/onedrive'
require_relative 'common/storages/storage'
require_relative 'common/search'

require_relative 'cloud/authorized/cloud_file_list'
require_relative 'cloud/authorized/cloud_top_tool_bar'
require_relative 'cloud/unauthorized/cloud_list'
require_relative 'cloud/unauthorized/onlyoffice/enterprise/' \
                 'onlyoffice_enterprise_login'
require_relative 'cloud/unauthorized/onlyoffice/enterprise/' \
                 'onlyoffice_enterprise_registration'
require_relative 'cloud/unauthorized/onlyoffice/portal_type_switcher'
require_relative 'cloud/unauthorized/onlyoffice/personal/' \
                 'onlyoffice_personal_login'
require_relative 'cloud/authorized/account/account'
require_relative 'cloud/authorized/account/context_account'
require_relative 'cloud/authorized/account/account_bar'

require_relative 'settings/settings'
require_relative 'settings/about'

require_relative 'onboarding/onboarding'

require_relative 'common/alert/alert'
