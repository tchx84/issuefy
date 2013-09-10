# Copyright (c) 2013 Martin Abente Lahaye. - martin.abente.lahaye@gmail.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA
#

Redmine::Plugin.register :issuefy do
  name 'Issuefy'
  author 'Martin Abente Lahaye'
  description 'Redmine plugin, for creating issues from a spreadsheet file'
  version '0.1.7'
  url 'http://github.com/tchx84/issuefy'
  author_url 'http://github.com/tchx84'
  permission :issuefy, { :issuefy => [:index, :file_upload] }
  menu :project_menu , :issuefy, {:controller => 'issuefy', :action => 'index'}, :caption => :issuefy
end
