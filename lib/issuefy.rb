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

require 'spreadsheet'

class IssuefyErrorTracker < Exception
end

class IssuefyErrorUser < Exception
end

class IssuefyErrorValue < Exception
end

class IssuefyErrorParent < Exception
end

module Issuefy

  TRACKER = 0
  ASSIGNED = 1
  SUBJECT = 2
  DESC = 3
  START = 4
  DUE = 5
  ESTIMATED = 6
  PARENT = 7

  def self.parse_parent(cell)
    return nil if cell.nil?
    parent = Issue.find_by_id(cell) || Issue.find_by_subject(cell)
    raise IssuefyErrorParent, cell if parent.nil?
    parent.id
  end

  def self.parse_tracker(cell)
    return nil if cell.nil?
    tracker = Tracker.find_by_name(cell.strip)
    raise IssuefyErrorTracker, cell if tracker.nil?
    tracker
  end

  def self.parse_user_or_group(cell)
    return nil if cell.nil?
    user = User.find_by_login(cell.strip)
    group = Group.find_by_lastname(cell.strip) if user.nil? 
    raise IssuefyErrorUser, cell if user.nil? && group.nil?
    user || group
  end

  def self.parse_date(cell)
    return nil if cell.nil?
    return DateTime.strptime(cell.strip, "%d/%m/%Y") rescue raise IssuefyErrorValue, cell if cell.class == String
    cell
  end

  def self.parse_text(cell)
    return nil if cell.nil?
    cell.strip
  end

  def self.parse_number(cell)
    return nil if cell.nil?
    Float(cell) rescue raise IssuefyErrorValue, cell
  end

  def self.parse_file(file, project, user)
    book = Spreadsheet.open(file.path)
    sheet = book.worksheet(0)
    count = 0

    Issue.transaction do
      sheet.each do |row|

        # subject MUST be present
        subject = parse_text(row[SUBJECT])
        next if subject.nil?

        issue = Issue.find_by_subject(subject) || Issue.new

        issue.project = project
        issue.author = user
        issue.subject = subject
        issue.tracker = parse_tracker(row[TRACKER])
        issue.assigned_to = parse_user_or_group(row[ASSIGNED])
        issue.description = parse_text(row[DESC])
        issue.start_date = parse_date(row[START])
        issue.due_date = parse_date(row[DUE])
        issue.estimated_hours = parse_number(row[ESTIMATED])
        issue.parent_issue_id = parse_parent(row[PARENT])

        issue.save!

        count += 1
      end
    end

    count
  end

end
