# frozen_string_literal: true

class CampaignFinanceController < ApplicationController
  def index; end
  def search
    available_categories = ['Candidate Loan', 'Contribution Total', 'Debts Owed', 'Disbursements Total', 'End Cash', 'Individual Total', 'PAC Total', 'Receipts Total', 'Refund Total']
    available_cycles = %w[2010 2012 2014 2016 2018 2020]
    
    selected_cycle = params[:cycle]
    selected_category = params[:category]

    if available_cycles.include?(selected_cycle) && available_categories.include?(selected_category)
      load_top_20_candidates(selected_cycle, selected_category)
      render :search
    else
      flash[:alert] = 'Select both a category and year to search.'
      redirect_to campaign_finance_index_path
    end
  end

  private

  def load_top_20_candidates(selected_cycle, selected_category)
    @top_20_candidates = CampaignFinance.fetch_top_20_candidates(selected_cycle, selected_category.downcase.gsub(' ', '-'))
    set_selected_category_and_api(selected_cycle, selected_category)
  end

  def set_selected_category_and_api(selected_cycle, selected_category)
    category_mapping = {
      'Candidate Loan'      => 'candidate_loans',
      'Contribution Total'  => 'total_contributions',
      'Debts Owed'          => 'debts_owed',
      'Disbursements Total' => 'total_disbursements',
      'End Cash'            => 'end_cash',
      'Individual Total'    => 'total_from_individuals',
      'PAC Total'           => 'total_from_pacs',
      'Receipts Total'      => 'total_receipts',
      'Refund Total'        => 'total_refunds'
    }
    @selected_category_api = category_mapping[selected_category]
    @selected_category = selected_category
    @selected_cycle = selected_cycle
  end
end