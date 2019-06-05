module SourceHelper
  # Markup for a document's source sidebar panel
  # rubocop:disable Rails/OutputSafety
  def source_panel_markup
    t('pulmap.source.historic_maps').html_safe if princeton_historic_map?
  end
  # rubocop:enable Rails/OutputSafety

  private

    # Check's if an item's call number matches those from the historic map collection.
    # @return [Bool]
    def princeton_historic_map?
      call_number = @document["call_number_s"]
      return unless @document.same_institution? && call_number
      /HMC/i.match(call_number)
    end
end
