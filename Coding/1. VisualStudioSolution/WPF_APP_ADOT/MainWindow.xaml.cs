using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WPF_APP_ADOT
{
    public partial class MainWindow : Window
    {
        private string connectionString = "Data Source=localhost;Initial Catalog=IowaCounties;Integrated Security=True";

        public MainWindow()
        {
            InitializeComponent();
            LoadCountyNames();
        }

        // Loads county names into ComboBoxes and initializes placeholder visibility
        private void LoadCountyNames()
        {
            var countyNames = GetAllCountyNames();
            County1ComboBox.ItemsSource = countyNames;
            County2ComboBox.ItemsSource = countyNames;

            // Set placeholders visibility based on initial text
            UpdatePlaceholderVisibility(County1ComboBox, County1Placeholder);
            UpdatePlaceholderVisibility(County2ComboBox, County2Placeholder);
        }

        // Retrieves all county names from the database
        private List<string> GetAllCountyNames()
        {
            List<string> countyNames = new List<string>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT county_name FROM county";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            countyNames.Add(reader["county_name"].ToString());
                        }
                    }
                }
            }

            return countyNames;
        }

        // Handles button click event to check if counties are adjacent and display result
        private void CheckAdjacencyButton_Click(object sender, RoutedEventArgs e)
        {
            string county1Name = County1ComboBox.Text;
            string county2Name = County2ComboBox.Text;

            int county1 = GetCountyIdByName(county1Name);
            int county2 = GetCountyIdByName(county2Name);

            // Validate selected counties
            if (county1 == 0 || county2 == 0)
            {
                string errorMessage = "";
                if (county1 == 0 && county2 == 0)
                {
                    errorMessage = "Both counties are invalid.";
                }
                else if (county1 == 0)
                {
                    errorMessage = "County 1 is invalid.";
                }
                else
                {
                    errorMessage = "County 2 is invalid.";
                }
                MessageBox.Show(errorMessage, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // Check if counties are the same
            if (county1 == county2)
            {
                String errorMessage = "Please choose two different counties";
                MessageBox.Show(errorMessage, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            // Check adjacency and display result
            bool areAdjacent = CheckAdjacency(county1, county2);
            ResultTextBlock.Text = areAdjacent ? "Counties are adjacent." : "Counties are not adjacent.";
        }

        // Retrieves county ID by its name from the database
        private int GetCountyIdByName(string countyName)
        {
            int countyId = 0;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT id FROM county WHERE county_name = @countyName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@countyName", countyName);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        countyId = Convert.ToInt32(result);
                    }
                }
            }
            return countyId;
        }

        // Checks adjacency of two counties using a stored procedure
        private bool CheckAdjacency(int county1, int county2)
        {
            bool result = false;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("spCheckAdjacency", conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@county1", county1);
                    cmd.Parameters.AddWithValue("@county2", county2);

                    SqlParameter outputParam = new SqlParameter("@result", System.Data.SqlDbType.Bit)
                    {
                        Direction = System.Data.ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outputParam);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    result = (bool)outputParam.Value;
                }
            }

            return result;
        }

        // Handles ComboBox selection change event to update placeholder visibility
        private void CountyComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ComboBox comboBox = sender as ComboBox;
            if (comboBox != null)
            {
                UpdatePlaceholderVisibility(comboBox, FindName(comboBox.Name.Replace("ComboBox", "Placeholder")) as TextBlock);
            }
        }

        // Updates visibility of placeholder based on ComboBox selection
        private void UpdatePlaceholderVisibility(ComboBox comboBox, TextBlock placeholder)
        {
            if (comboBox.SelectedIndex == -1 && string.IsNullOrEmpty(comboBox.Text))
            {
                placeholder.Visibility = Visibility.Visible;
            }
            else
            {
                placeholder.Visibility = Visibility.Hidden;
            }
        }
    }
}
