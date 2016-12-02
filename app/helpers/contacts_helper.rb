module ContactsHelper
  def find_last_date(new_assignment_param)
    current_date = DateTime.strptime(new_assignment_param["effective_start_date(1i)"] + "-" +
                                         new_assignment_param["effective_start_date(2i)"] + "-" +
                                         new_assignment_param["effective_start_date(3i)"], "%Y-%m-%d")
    return current_date.yesterday.strftime("%Y-%m-%d")
  end

  def update_parameters(contact_params)
    new_assignment_index = -1
    original_assignment_index = -1
    contact_params[:contact_assignments_attributes].each_with_index  do |assignment, index|
      if assignment[1]["effective_end_date"] == ""
        new_assignment_index = index
      else
        if assignment[1]["effective_end_date"].to_s.split("-")[0] == "9999"
          original_assignment_index = index
        end
      end
    end
    cp = contact_params
    if new_assignment_index > -1 and original_assignment_index > -1
      cp[:contact_assignments_attributes].values[new_assignment_index]["effective_end_date"] = "9999-12-31"
      original_end_date = find_last_date(cp[:contact_assignments_attributes].values[new_assignment_index])
      cp[:contact_assignments_attributes].values[original_assignment_index]["effective_end_date"] =
          original_end_date
    else
      if new_assignment_index > -1
        cp[:contact_assignments_attributes].values[new_assignment_index]["effective_end_date"] = "9999-12-31"
      end
    end

    return cp
  end
end
