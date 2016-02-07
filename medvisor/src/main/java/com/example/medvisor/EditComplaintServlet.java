/**
 * Copyright 2014-2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//[START all]
package com.example.medvisor;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

public class EditComplaintServlet extends HttpServlet {
  @Override
  public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    String content;

    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    String operation = req.getParameter("operation");
    String id = req.getParameter("id");
    Key<UserInfo> parent = Key.create(UserInfo.class, user.getEmail());
    if (operation.equals("delete")) {
      ObjectifyService.ofy()
        .delete()
        .type(UserComplaint.class)
        .parent(parent)
        .id(Long.parseLong(id))
        .now();
      resp.sendRedirect("/Patient.jsp");
    } else if (operation.equals("edit")) {
      content = ObjectifyService.ofy()
        .load()
        .type(UserComplaint.class)
        .parent(parent)
        .id(Long.parseLong(id))
        .now()
        .content;
      resp.sendRedirect("/Patient.jsp?content="+content);
      ObjectifyService.ofy()
        .delete()
        .type(UserComplaint.class)
        .parent(parent)
        .id(Long.parseLong(id))
        .now();
    }
  }
}
//[END all]
